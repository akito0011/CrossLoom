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
        await fetchGameDetails(gameID: id)
    }

    // Funzione asincrona per fare la richiesta API
    private mutating func fetchGameDetails(gameID: Int) async {
        // Costruisci l'URL dell'API di Steam
        let urlString = "https://api.steampowered.com/ISteamUserStats/GetGameStats/v1/?appid=\(gameID)"
        guard let url = URL(string: urlString) else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            // Decodifica i dati ricevuti da Steam
            let decoder = JSONDecoder()
            if let gameDetails = try? decoder.decode(SteamGameDetails.self, from: data) {
                self.name = gameDetails.name
                self.thumbnail = gameDetails.thumbnail
                self.genres = gameDetails.genres
            }
        } catch {
            print("Errore nel recuperare i dettagli del gioco: \(error)")
        }
    }
    
}

// Struttura per i dettagli del gioco che riceviamo dall'API Steam
struct SteamGameDetails: Decodable {
    let id: Int
    let name: String
    let thumbnail: String
    let genres: [String]
}
