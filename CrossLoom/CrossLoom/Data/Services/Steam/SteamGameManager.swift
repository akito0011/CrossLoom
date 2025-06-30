import Foundation

class SteamGameManager: ObservableObject {
    @Published var games: [SteamGame] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let apiKey = "93E30850276916ECF98E706D4CC94534"

    func fetchGames(for steamId: String) {
        errorMessage = nil
        isLoading = true

        let urlString =
        "https://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=\(apiKey)&steamid=\(steamId)&include_appinfo=true&format=json"

        guard let url = URL(string: urlString) else {
            errorMessage = "URL non valido"
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false

                if let error = error {
                    self?.errorMessage = "Errore di rete: \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    self?.errorMessage = "Nessun dato ricevuto"
                    return
                }

                do {
                    let decoded = try JSONDecoder().decode(SteamResponse.self, from: data)
                    self?.games = decoded.response.games.map {
                        SteamGame(
                            id: $0.appid,
                            name: $0.name ?? "Unknown",
                            playtimeForever: $0.playtime_forever,
                            imageUrl: "https://cdn.cloudflare.steamstatic.com/steam/apps/\($0.appid)/header.jpg"
                        )
                    }
                } catch {
                    self?.errorMessage = "Errore di decodifica: \(error.localizedDescription)"
                    print("Errore di decoding:", error)
                }
            }
        }.resume()
    }
}
