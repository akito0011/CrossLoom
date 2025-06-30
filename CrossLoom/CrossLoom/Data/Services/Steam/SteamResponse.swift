struct SteamResponse: Codable {
    let response: GameList
}

struct GameList: Codable {
    let game_count: Int
    let games: [GameData]
}

struct GameData: Codable {
    let appid: Int
    let name: String?
    let playtime_forever: Int
}
