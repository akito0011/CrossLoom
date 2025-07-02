import SwiftUI

struct Home: View {
    
    @EnvironmentObject var manager: UserManager
    @EnvironmentObject var steamAuthManager: SteamAuthManager
    @ObservedObject var viewModel: SteamGameViewModel
    @State private var selectedGameID: Int?


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
                        NavBar(viewModel: viewModel)
                            .padding(.top, 10)
                        
                        if manager.user.linkedPlatforms.isEmpty {
                            
                            Image("home-tutorial")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .padding()
                                .shadow(color: .shadow, radius: 8, x: 0, y: 6)
                        } else {
                            SuggestionButton(viewModel: viewModel)
                            
                            if viewModel.games.isEmpty{
                                Text("Set up your profile and public library")
                                    .font(.helvetica(fontStyle: .title2, fontWeight: .bold))
                                    .foregroundColor(.buttonBackground)
                                    .multilineTextAlignment(.center)
                                    .padding()
                            }

                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(viewModel.games.sorted(by: { $0.playtime > $1.playtime })) { game in
                                    NavigationLink {
                                        GameDetails(viewModel: viewModel, gameID: game.id)
                                    } label: {
                                        GameCard(
                                            name: game.name,
                                            subText: "Hours",
                                            hour: game.playtime / 60,
                                            urlCover: game.urlCover
                                        )
                                        .shadow(color: .shadow, radius: 8, x: 0, y: 4)
                                    }
                                }
                            }

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
                    Task{
                        await viewModel.initializer(for: steamId)
                    }
                }
            }
        }
        // Se già loggato, mostra i giochi
        .onAppear {
            if manager.user.linkedPlatforms.contains(.steam),
               viewModel.games.isEmpty,
               let steamId = manager.user.steamId {
                Task{
                    await viewModel.initializer(for: steamId)
                    
                }
            }
        }
    }
}

#Preview {
    Home(viewModel: SteamGameViewModel())
        .environmentObject(UserManager())
        .environmentObject(SteamAuthManager())
}
