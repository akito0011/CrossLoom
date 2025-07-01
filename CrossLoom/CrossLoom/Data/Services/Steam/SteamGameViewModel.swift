import Foundation


class SteamGameViewModel: ObservableObject {
    @Published var games: [SteamGame] = []
    @Published var suggestedGames : [SuggestedGame] = []
    private var suggestionService =  SuggestionService()
    
    func initializer(for steamId: String){
        fetchGames(for: steamId)
        loadSuggestions()
        print(suggestedGames)
    }

    func loadSuggestions(){
        var rating : [Int64: Double] = [:]
        for game in games{
            rating[Int64(game.id)] = getRating(game: game)
        }
        suggestedGames = suggestionService.getSuggestedGames(rating: rating)
    }
    
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
    
    private func getRating(game: SteamGame) -> Double{
        
        switch Int((Double(game.playtime)/60).rounded()) {
        case 1...3:
            return 1.0
        case 4...10:
            return 2.0
        case 11...25:
            return 3.0
        case 26...50:
            return 4.0
        default:
            return 5.0
        }
    }
}



