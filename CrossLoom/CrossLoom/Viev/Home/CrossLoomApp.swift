extension Notification.Name {
    static let didReceiveSteamID = Notification.Name("didReceiveSteamID")
}
import SwiftUI

@main
struct CrossLoomApp: App {
    
    @StateObject private var userManager = UserManager()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var steamAuthManager = SteamAuthManager()
    @StateObject private var steamGameViewModel = SteamGameViewModel()


    var body: some Scene {
        WindowGroup {
            Home(viewModel: steamGameViewModel)
                .environmentObject(steamAuthManager)
                .environmentObject(userManager)
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
