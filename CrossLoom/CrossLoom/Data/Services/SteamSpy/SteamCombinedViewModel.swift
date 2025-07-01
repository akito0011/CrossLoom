import Foundation

struct SteamGame1: Codable, Identifiable {
    let id: Int
    let name: String
    let playtime: Int      // tue ore giocate
    let urlCover: String
    let average_forever: Int? // media ore da SteamSpy (opzionale)

    private enum CodingKeys: String, CodingKey {
        case id = "appid"
        case name
        case playtime = "playtime_forever"
        case average_forever
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? "Unknown"
        self.playtime = try container.decodeIfPresent(Int.self, forKey: .playtime) ?? 0
        self.average_forever = try container.decodeIfPresent(Int.self, forKey: .average_forever)
        self.urlCover = "https://cdn.cloudflare.steamstatic.com/steam/apps/\(self.id)/header.jpg"
    }
}

struct RatedGame: Identifiable {
    let id: Int
    let game: SteamGame
    let rating: Int
}

class SteamCombinedViewModel: ObservableObject {
    @Published var ratedGames: [RatedGame] = []
    @Published var errorMessage: String?

    private var myGames: [SteamGame] = []
    private var averageGames: [SteamGame] = []

    private func rating(playtime: Int, average: Int) -> Int {
        guard average > 0 else { return 1 }
        let ratio = Double(playtime) / Double(average)
        switch ratio {
        case ..<0.5:
            return 1
        case 0.5..<0.75:
            return 2
        case 0.75..<1.25:
            return 3
        case 1.25..<1.5:
            return 4
        default:
            return 5
        }
    }

    func fetchMyGames(steamId: String, completion: @escaping () -> Void) {
        guard let url = URL(string: "https://api.steampowered.com/IPlayerService/GetOwnedGames/v1/?key=93E836B627946EC9F6FB704DC0495433&steamid=\(steamId)&include_appinfo=true&format=json") else {
            DispatchQueue.main.async {
                self.errorMessage = "URL non valido per Steam"
            }
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Errore Steam: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "Nessun dato Steam ricevuto"
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(SteamResponse.self, from: data)
                DispatchQueue.main.async {
                    self.myGames = decoded.response.games ?? []
                    completion()
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Errore decodifica Steam: \(error.localizedDescription)"
                }
            }
        }.resume()
    }

    func fetchAverageGames(completion: @escaping () -> Void) {
        guard let url = URL(string: "https://steamspy.com/api.php?request=all") else {
            DispatchQueue.main.async {
                self.errorMessage = "URL non valido per SteamSpy"
            }
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Errore SteamSpy: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "Nessun dato SteamSpy ricevuto"
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode([String: SteamGame].self, from: data)
                DispatchQueue.main.async {
                    self.averageGames = Array(decoded.values)
                        .filter { $0.average_forever ?? 0 > 0 }
                    completion()
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Errore decodifica SteamSpy: \(error.localizedDescription)"
                }
            }
        }.resume()
    }

    func loadData(steamId: String) {
        errorMessage = nil
        ratedGames = []

        fetchAverageGames { [weak self] in
            guard let self = self else { return }
            self.fetchMyGames(steamId: steamId) {
                self.mergeAndRateGames()
            }
        }
    }

    private func mergeAndRateGames() {
        let averageDict = Dictionary(uniqueKeysWithValues: averageGames.map { ($0.id, $0.average_forever ?? 0) })

        var tempRatedGames: [RatedGame] = []

        for game in myGames {
            let avg = averageDict[game.id] ?? 0
            let rate = rating(playtime: game.playtime, average: avg)
            tempRatedGames.append(RatedGame(id: game.id, game: game, rating: rate))
        }

        tempRatedGames.sort {
            if $0.rating == $1.rating {
                return $0.game.playtime > $1.game.playtime
            }
            return $0.rating > $1.rating
        }

        DispatchQueue.main.async {
            self.ratedGames = tempRatedGames
        }
    }
}

struct SteamResponse1: Codable {
    let response: SteamGamesResponse
}

struct SteamGamesResponse1: Codable {
    let games: [SteamGame]?
}
