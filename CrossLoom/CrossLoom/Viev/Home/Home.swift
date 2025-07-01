import SwiftUI

struct Home: View {
    
    @EnvironmentObject var manager: UserManager
    @EnvironmentObject var steamAuthManager: SteamAuthManager
    @ObservedObject var viewModel: SteamGameViewModel

    // colonne dinamiche per le card(in base alla larghezza dello schermo)
    let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 10)
    ]

    var body: some View {
        
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea(.all)
                
                ScrollView(.vertical) {
                    VStack {
                        NavBar()
                            .padding(.top, 10)

                        if manager.user.linkedPlatforms.isEmpty {
                            Text("Connect some platform to start!")
                                .font(.helvetica(fontStyle: .title2, fontWeight: .bold))
                                .foregroundColor(.buttonBackground)
                                .multilineTextAlignment(.center)
                                .padding()
                        } else {
                            SuggestionButton()

                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(viewModel.games) { game in
                                    GameCard(
                                        name: game.name,
                                        hour: game.playtime/60,
                                        urlCover: game.urlCover
                                    )
                                    .shadow(color: .shadow, radius: 6, x: 2, y: 4)
                                }
                            }
                            // RIMOSSO `.frame(maxWidth: 80)`
                            .padding(.horizontal)
                        }

                        Spacer()
                    }
                }
            }
        }
        // Aggiornamento login Steam
        .onChange(of: steamAuthManager.loginSuccess) { success in
            if success {
                if !manager.user.linkedPlatforms.contains(.steam) {
                    var updatedUser = manager.user
                    updatedUser.linkedPlatforms.append(.steam)
                    manager.user = updatedUser
                    manager.save()
                }

                // Caricamento giochi Steam
                if let steamId = manager.user.steamId {
                    viewModel.initializer(for: steamId)
                }
            }
        }
        // Se già loggato, mostra i giochi
        .onAppear {
            if manager.user.linkedPlatforms.contains(.steam),
               viewModel.games.isEmpty,
               let steamId = manager.user.steamId {
                viewModel.initializer(for: steamId)
            }
        }
    }
}

#Preview {
    Home(viewModel: SteamGameViewModel())
        .environmentObject(UserManager())
        .environmentObject(SteamAuthManager())
}
