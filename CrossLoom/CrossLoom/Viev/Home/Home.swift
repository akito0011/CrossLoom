import SwiftUI

struct Home: View {
    
    @State private var platform: [Platform] = []
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.background.ignoresSafeArea(.all)
                VStack {
                    
                    NavBar(username: "Mirko", imgUrl: "profile", platform: platform)
                    
                    
                    //Controllo se l'utente ha  collegato degli account
                    if platform.isEmpty {
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
    }
}

#Preview {
    Home()
}
