import Foundation
import AuthenticationServices
import SwiftUI

class SteamAuthManager: NSObject, ASWebAuthenticationPresentationContextProviding {
    
    @AppStorage("steamID") var savedSteamID: String?

    static let shared = SteamAuthManager()

    private var authSession: ASWebAuthenticationSession?

    func startSteamLogin(completion: @escaping (Result<String, Error>) -> Void) {
        let redirectURI = "crossloom://steam_auth"
        let steamOpenIDURL = "https://cross-loom.vercel.app/api/steam"

        guard let url = URL(string: steamOpenIDURL) else {
            completion(.failure(NSError(domain: "SteamAuth", code: 1, userInfo: [NSLocalizedDescriptionKey: "URL non valida"])))
            return
        }

        authSession = ASWebAuthenticationSession(
            url: url,
            callbackURLScheme: "crossloom"
        ) { callbackURL, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let callbackURL = callbackURL,
                  let components = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false),
                  let claimedID = components.queryItems?.first(where: { $0.name == "openid.claimed_id" })?.value else {
                completion(.failure(NSError(domain: "SteamAuth", code: 2, userInfo: [NSLocalizedDescriptionKey: "ID non trovato"])))
                return
            }

            let steamID = claimedID.components(separatedBy: "/").last ?? ""
            completion(.success(steamID))
        }

        authSession?.presentationContextProvider = self
        authSession?.start()
    }

    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        // Cerca la finestra attiva della scena
        guard let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
            let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return ASPresentationAnchor()
        }

        return window
    }
}
