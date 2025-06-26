import Foundation

struct User: Codable {
    var username: String = "User102"
    var imgURL: String = "profile" // nome file immagine salvata nel device
    var linkedPlatforms: [Platform] = []
}

class UserManager: ObservableObject {
    @Published var user: User = User()
    
    private let savePath = FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("user.json")
    
    init() {
        load()
    }
    
    func load() {
        if let data = try? Data(contentsOf: savePath),
           let decoded = try? JSONDecoder().decode(User.self, from: data) {
            self.user = decoded
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(user) {
            try? data.write(to: savePath)
        }
    }
}

enum Platform: String, CaseIterable, Identifiable, Hashable, Codable {
    case steam
    case xbox
//    case playstation
//    case nintendo

    var id: String { self.rawValue }

    var displayName: String {
        switch self {
        case .steam: return "Steam"
        case .xbox: return "Xbox"
//        case .playstation: return "PlayStation"
//        case .nintendo: return "Nintendo"
        }
    }
}
