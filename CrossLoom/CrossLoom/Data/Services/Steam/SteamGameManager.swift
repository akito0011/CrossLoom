import Foundation

class SteamGameManager: ObservableObject {
    @Published var games: [SteamGame] = []
    @Published var errorMessage: String?

    func fetchGames(for steamId: String) {
        guard let url = URL(string: "https://api.steampowered.com/IPlayerService/GetOwnedGames/v1/?key=93E836B627946EC9F6FB704DC0495433&steamid=\(steamId)&include_appinfo=true&format=json") else {
            DispatchQueue.main.async {
                self.errorMessage = "URL non valido"
            }
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                self?.errorMessage = nil
            }

            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "Errore di rete: \(error.localizedDescription)"
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
                let decoded = try JSONDecoder().decode(SteamResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.games = decoded.response.games ?? []
                }
            } catch {
                DispatchQueue.main.async {
                    self?.errorMessage = "Errore di decodifica: \(error.localizedDescription)"
                }

                if let jsonString = String(data: data, encoding: .utf8) {
                    print("❌ Errore decodifica JSON:\n\(jsonString)")
                }
            }
        }

        task.resume()
    }
}
