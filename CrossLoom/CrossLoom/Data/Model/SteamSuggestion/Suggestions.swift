// Struttura per il gioco, utilizzata nell'input e nell'output
struct SuggestedGame: Identifiable {
    let id: Int
    let name: String = ""
    let playtime: Int = 0
    let rating: Double
    
    init(id: Int, rating: Double) {
        self.id = id
        self.rating = rating
        
    }
}

// Struttura per la risposta dell'API di Steam
struct SteamGameDetails: Identifiable {
    let id: Int
    let name: String
    let thumbnail: String
    let genres: [String]
}



