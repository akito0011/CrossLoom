import Foundation

struct SteamResponse: Codable {
    let response: SteamGamesResponse
}

struct SteamGamesResponse: Codable {
    let games: [SteamGame]?
}
