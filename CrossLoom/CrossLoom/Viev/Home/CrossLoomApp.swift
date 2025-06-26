extension Notification.Name {
    static let didReceiveSteamID = Notification.Name("didReceiveSteamID")
}
import SwiftUI

@main
struct CrossLoomApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var steamAuthManager = SteamAuthManager()

    var body: some Scene {
        WindowGroup {
            Home()
                .environmentObject(steamAuthManager)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Supporta myapp://auth-callback?steamid=123456789
        guard url.scheme == "myapp",
              url.host == "auth-callback",
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let steamId = components.queryItems?.first(where: { $0.name == "steamid" })?.value
        else {
            return false
        }

        print("✅ SteamID ricevuto: \(steamId)")

        // Salva lo steamId (puoi anche salvare su UserDefaults o EnvironmentObject)
        NotificationCenter.default.post(
            name: .didReceiveSteamID,
            object: nil,
            userInfo: ["steamid": steamId]
        )

        return true
    }
}
