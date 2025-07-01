import Foundation

class SteamSpyViewModel: ObservableObject {
    @Published var games: [SteamGame] = []

    func fetchGames() {
        guard let url = URL(string: "https://steamspy.com/api.php?request=all") else {
            print("URL non valido")
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Errore: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("Dati assenti")
                return
            }

            do {
                let decoded = try JSONDecoder().decode([String: SteamGame].self, from: data)
                let gamesArray = Array(decoded.values)

                DispatchQueue.main.async {
                    self.games = gamesArray
                        .filter { $0.average_forever > 0 }
                        .sorted { $0.average_forever > $1.average_forever }
                }
            } catch {
                print("Errore decoding JSON: \(error)")
            }
        }.resume()
    }
}

