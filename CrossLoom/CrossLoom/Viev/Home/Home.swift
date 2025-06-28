import SwiftUI

struct Home: View {
    
    @EnvironmentObject var manager: UserManager
    @EnvironmentObject var steamAuthManager: SteamAuthManager
    
    var body: some View {
        
        NavigationStack{
            ZStack{
                Color.background.ignoresSafeArea(.all)
                VStack {
                    
                    NavBar()
                    
                    //Controllo se l'utente ha  collegato degli account
                    if manager.user.linkedPlatforms.isEmpty {
                        // Messaggio se non ha piattaforme collegate
                        Text("Connect some platform to start!")
                            .font(.helvetica(fontStyle: .title2, fontWeight: .bold))
                            .foregroundColor(.buttonBackground)
                            .multilineTextAlignment(.center)
                            .padding()
                    }else{
                        
                        SuggestionButton()
                        
                        HStack(spacing: 10){
                            GameCard(name: "Apex Legends", hour: 10020, urlCover: "https://is.gd/HM0Xaj")
                            GameCard(name: "League Of Legends", hour: 100, urlCover: "https://is.gd/xADE5c")
                        }
                    }
                    Spacer()
                }//END VSTACK
                .frame(maxWidth: .infinity)
            }
        }//END NavigationStack
        .onChange(of: steamAuthManager.loginSuccess) { success in
            if success {
                if !manager.user.linkedPlatforms.contains(.steam) {
                    var updatedUser = manager.user
                    updatedUser.linkedPlatforms.append(.steam)
                    manager.user = updatedUser
                    manager.save()
                }
            }
        }
    }
}

#Preview {
    Home()
        .environmentObject(UserManager())
        .environmentObject(SteamAuthManager())
}
