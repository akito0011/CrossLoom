import Foundation

// Struct per i giochi suggeriti con un costruttore asincrono
struct SuggestedGame: Identifiable {
    let id: Int
    var name: String
    var thumbnail: String
    var genres: [String]
    var rating: Double

    // Inizializzatore asincrono che carica i dati da Steam
    init(id: Int, rating: Double) async {
        self.id = id
        self.rating = rating
        self.name = ""
        self.thumbnail = ""
        self.genres = []

        // Recupera i dettagli del gioco da Steam
        let details = await fetchGameDetails(gameID: id)
        
        if let details = details {
            self.name = details.name
            self.thumbnail = details.header_image
            self.genres = details.genres.map({$0.description})
        }
        
//        print(self)
    }

    // Funzione asincrona per fare la richiesta API
    private mutating func fetchGameDetails(gameID: Int) async -> SteamGameResponseDetails? {
        // Costruisci l'URL dell'API di Steam
        let urlString = "https://store.steampowered.com/api/appdetails?appids=\(gameID)"
        guard let url = URL(string: urlString) else { return nil}
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            // Decodifica i dati ricevuti da Steam
            let decoder = JSONDecoder()

            if let gameDetails = try? decoder.decode([String: SteamGameResponse].self, from: data) {
                print("------------------------------")
                print(gameDetails[String(id)]?.data.name)
                return gameDetails[String(id)]?.data
            }
            
        } catch {
        }
        return nil
    }
        
    
}

// Struttura per i dettagli del gioco che riceviamo dall'API Steam

struct SteamGameResponse: Codable {
    let success: Bool
    let data: SteamGameResponseDetails
}

struct SteamGameResponseDetails: Codable {
//    let id: Int
    let name: String
    let header_image: String
    let genres: [Genre]
}

struct SteamGameDetails: Codable {
//    let id: Int
    let name: String
    let thumbnail: String
    let genres: [Genre]
}

struct Genre: Codable {
    let id: String
    let description: String
}
