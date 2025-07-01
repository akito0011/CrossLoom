import SwiftUI

// MARK: - Modelli

struct SteamGame2: Identifiable, Codable {
    let id: Int
    let name: String
    let playtime: Int
    let urlCover: String

    private enum CodingKeys: String, CodingKey {
        case id = "appid"
        case name
        case playtime = "playtime_forever"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? "Unknown"
        playtime = try container.decodeIfPresent(Int.self, forKey: .playtime) ?? 0
        urlCover = "https://cdn.cloudflare.steamstatic.com/steam/apps/\(id)/header.jpg"
    }
}

struct SteamSpyGame: Codable {
    let appid: Int
    let average_forever: Int
}

struct SteamResponse2: Codable {
    let response: SteamGamesResponse2
}

struct SteamGamesResponse2: Codable {
    let games: [SteamGame2]?
}

// MARK: - ViewModel

class SteamTestViewModel: ObservableObject {
    @Published var userGames: [SteamGame2] = []
    @Published var spyGames: [SteamSpyGame] = []
    @Published var errorMessage: String?
    @Published var isLoading = false

    let steamApiKey = "93E836B627946EC9F6FB704DC0495433"
    let steamId = "76561198202139404"

    func fetchUserGames() {
        isLoading = true
        errorMessage = nil

        let urlString = "https://api.steampowered.com/IPlayerService/GetOwnedGames/v1/?key=\(steamApiKey)&steamid=\(steamId)&include_appinfo=true&format=json"

        guard let url = URL(string: urlString) else {
            errorMessage = "URL non valido"
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            DispatchQueue.main.async { self?.isLoading = false }

            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "Errore rete: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self?.errorMessage = "Nessun dato ricevuto"
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(SteamResponse2.self, from: data)
                DispatchQueue.main.async {
                    self?.userGames = decoded.response.games ?? []
                }
            } catch {
                DispatchQueue.main.async {
                    self?.errorMessage = "Errore decodifica Steam: \(error.localizedDescription)"
                }
            }
        }.resume()
    }

    func fetchSpyGames() {
        isLoading = true
        errorMessage = nil

        guard let url = URL(string: "https://steamspy.com/api.php?request=all") else {
            errorMessage = "URL SteamSpy non valido"
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            DispatchQueue.main.async { self?.isLoading = false }

            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "Errore rete SteamSpy: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self?.errorMessage = "Nessun dato ricevuto da SteamSpy"
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode([String: SteamSpyGame].self, from: data)
                DispatchQueue.main.async {
                    self?.spyGames = Array(decoded.values)
                }
            } catch {
                DispatchQueue.main.async {
                    self?.errorMessage = "Errore decodifica SteamSpy: \(error.localizedDescription)"
                }
            }
        }.resume()
    }

    func rating(for game: SteamGame2) -> Int {
        guard let spyGame = spyGames.first(where: { $0.appid == game.id }) else {
            return 0
        }

        let userHours = Double(game.playtime) / 60.0
        let avgHours = Double(spyGame.average_forever) / 60.0

        guard avgHours > 0 else { return 0 }

        let diffPercent = (userHours - avgHours) / avgHours

        switch diffPercent {
        case ..<(-0.5): return 1
        case (-0.5)..<(-0.2): return 2
        case (-0.2)..<0.2: return 3
        case 0.2..<0.5: return 4
        default: return 5
        }
    }
}

// MARK: - View

struct SteamTestView: View {
    @StateObject private var viewModel = SteamTestViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Caricamento...")
                        .padding()
                }

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }

                List(viewModel.userGames) { game in
                    HStack(spacing: 12) {
                        AsyncImage(url: URL(string: game.urlCover)) { image in
                            image.resizable()
                                .scaledToFit()
                        } placeholder: {
                            Color.gray.opacity(0.3)
                        }
                        .frame(width: 80, height: 45)
                        .cornerRadius(6)

                        VStack(alignment: .leading) {
                            Text(game.name)
                                .font(.headline)
                            Text("Ore giocate: \(game.playtime / 60)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            let rating = viewModel.rating(for: game)
                            HStack(spacing: 2) {
                                ForEach(1...5, id: \ .self) { star in
                                    Image(systemName: star <= rating ? "star.fill" : "star")
                                        .foregroundColor(star <= rating ? .yellow : .gray)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Confronto Giochi")
            .onAppear {
                viewModel.fetchSpyGames()
                viewModel.fetchUserGames()
            }
        }
    }
}

// MARK: - Entry Point

struct ContentView: View {
    var body: some View {
        SteamTestView()
    }
}
#Preview {
    ContentView()
}