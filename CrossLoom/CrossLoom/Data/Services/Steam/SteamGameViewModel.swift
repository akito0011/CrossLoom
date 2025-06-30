import Foundation

class SteamGameViewModel: ObservableObject {
    @Published var games: [SteamGame] = []

    func fetchGames(for steamId: String) {
        guard let steamId = UserDefaults.standard.string(forKey: "steamID") else {
            print("❌ SteamID non trovato nei UserDefaults")
            return
        }
        let urlString = "https://api.steampowered.com/IPlayerService/GetOwnedGames/v1/?key=93E30850276916ECF98E706D4CC94534&steamid=\(steamId)&include_appinfo=true&format=json"


        guard let url = URL(string: urlString) else {
            print("❌ URL non valido")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Errore durante la richiesta: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("❌ Nessun dato ricevuto")
                return
            }

            do {
                let decoded = try JSONDecoder().decode(SteamResponse.self, from: data)
                DispatchQueue.main.async {
                    self.games = decoded.response.games ?? []
                }
            } catch {
                print("❌ Errore decodifica JSON: \(error)")
                if let string = String(data: data, encoding: .utf8) {
                    print("📦 Risposta ricevuta: \(string)")
                }
            }
        }.resume()
    }
}
