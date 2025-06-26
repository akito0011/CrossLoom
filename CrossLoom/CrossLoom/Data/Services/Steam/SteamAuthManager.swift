import Foundation
import AuthenticationServices
import SwiftUI

class SteamAuthManager: NSObject, ObservableObject {
    @Published var steamID: String?

    private var authSession: ASWebAuthenticationSession?

    func startSteamLogin() {
        let redirectScheme = "myapp" // Deve corrispondere a quello registrato in Info.plist
        let authURLString = "https://cross-loom.vercel.app/api/steam"
        
        guard let authURL = URL(string: authURLString) else {
            print("❌ URL di autenticazione non valido.")
            return
        }

        authSession = ASWebAuthenticationSession(
            url: authURL,
            callbackURLScheme: redirectScheme
        ) { [weak self] callbackURL, error in
            if let error = error {
                print("❌ Errore Steam login: \(error.localizedDescription)")
                return
            }

            guard let callbackURL = callbackURL,
                  let components = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false),
                  let steamID = components.queryItems?.first(where: { $0.name == "steamid" })?.value
            else {
                print("❌ Steam ID non trovato nel callback")
                return
            }

            DispatchQueue.main.async {
                print("✅ Steam login riuscito, SteamID: \(steamID)")
                self?.steamID = steamID
                // Salva se necessario
                UserDefaults.standard.set(steamID, forKey: "steamID")
            }
        }

        // Per mostrare il login sopra la UI
        authSession?.presentationContextProvider = self
        authSession?.prefersEphemeralWebBrowserSession = true // evita il login persistente
        authSession?.start()
    }
}

// MARK: - Per supportare la presentazione del browser su iOS
extension SteamAuthManager: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }
}
