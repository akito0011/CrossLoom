import Foundation

struct SteamGame: Codable, Identifiable {
    let id: Int
    let name: String
    let playtime: Int
    let urlCover: String

    private enum CodingKeys: String, CodingKey {
        case id = "appid"
        case name
        case playtime = "playtime_forever"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? "Unknown"
        self.playtime = try container.decode(Int.self, forKey: .playtime)
        self.urlCover = "https://cdn.cloudflare.steamstatic.com/steam/apps/\(self.id)/header.jpg"
    }
}
