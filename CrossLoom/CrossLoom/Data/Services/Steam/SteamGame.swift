struct SteamGame: Codable, Identifiable {
    let id: Int
    let name: String
    let playtime: Int
    let urlCover: String
    let average_forever: Int
    let appid: Int


    private enum CodingKeys: String, CodingKey {
        case id = "appid"
        case name
        case playtime = "playtime_forever"
        case average_forever
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? "Unknown"
        self.playtime = try container.decode(Int.self, forKey: .playtime)
        self.average_forever = try container.decodeIfPresent(Int.self, forKey: .average_forever) ?? 0
        self.urlCover = "https://cdn.cloudflare.steamstatic.com/steam/apps/\(self.id)/header.jpg"
        self.appid = self.id
    }
}
