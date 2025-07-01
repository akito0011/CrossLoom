import Foundation

class SteamGameViewModel: ObservableObject {
    @Published var games: [SteamGame] = []
    @Published var suggestedGames : [SuggestedGame] = []
    @Published var detailsGame: SteamDetailedData?
    private var suggestionService =  SuggestionService()
    
    func initializer(for steamId: String) async{
        fetchGames(for: steamId)
        await loadSuggestions()
        print(suggestedGames)
    }

    func loadSuggestions() async{
        var rating : [Int64: Double] = [:]
        for game in games{
            rating[Int64(game.id)] = getRating(game: game)
        }
        suggestedGames = await suggestionService.getSuggestedGames(rating: rating)
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
    
    private func gameDetailInfo(for gameID: Int) async ->SteamGameResponseData?{
        // Costruisci l'URL dell'API di Steam
        let urlString = "https://store.steampowered.com/api/appdetails?appids=\(gameID)"
        guard let url = URL(string: urlString) else { return nil}
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            // Decodifica i dati ricevuti da Steam
            let decoder = JSONDecoder()

            if let gameDetails = try? decoder.decode([String: SteamGameResponseDetailed].self, from: data) {
                print("------------------------------")
                let details = gameDetails[String(gameID)]?.data
                return details ?? nil
            }
            
        } catch {
        }
        return nil
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
    
    func initializeDetails(id: Int) async{
        detailsGame = await SteamDetailedData(id: id)
    }
    
    struct SteamDetailedData: Codable {
        var name: String
        var headerImage: String
        var detailedDescription: String
        var AchievementNames: [String?] = []
        var AchievementImage: [String?] = []
        
        init(id :Int) async{
            let details = await SteamGameViewModel().gameDetailInfo(for: id )
            
            self.name = details?.name ?? "N/A"
            self.headerImage = details?.headerImage ?? ""
            self.detailedDescription = details?.detailedDescription ?? ""
            
            if let highlightedAchievements = details?.achievements?.highlighted {
                for achievement in highlightedAchievements {
                    self.AchievementImage.append(achievement.path)
                    self.AchievementNames.append(achievement.name)
                }
            }
            print(self)
        }
    }
    
    
    struct SteamGameResponseDetailed: Codable {
        let success: Bool
        let data: SteamGameResponseData
    }

    struct SteamGameResponseData: Codable {
        let name: String
        let headerImage: String
        let detailedDescription: String
        let achievements: Achievements?

        enum CodingKeys: String, CodingKey {
            case name
            case headerImage = "header_image"
            case detailedDescription = "detailed_description"
            case achievements
        }
    }



    struct Achievements: Codable {
        let total: Int?
        let highlighted: [Achievement]?
    }

    struct Achievement: Codable {
        let name: String?
        let path: String?
    }
    
}



