import Foundation

struct User{
    var username: String = "User102"
    var imgURL: String = "profile"
}

enum Platform: String, CaseIterable, Identifiable, Hashable {
    case steam
    case xbox
    case playstation
    case nintendo

    var id: String { self.rawValue }

    var displayName: String {
        switch self {
        case .steam: return "Steam"
        case .xbox: return "Xbox"
        case .playstation: return "PlayStation"
        case .nintendo: return "Nintendo"
        }
    }
}
