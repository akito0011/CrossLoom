import SwiftUI

struct PlatformButton: View {
    @EnvironmentObject var steamAuth: SteamAuthManager
    @State var icon: String
    @State var text: String
    
    var body: some View {
        Button(action: {
            
            if text == "Steam" {
                steamAuth.startSteamLogin()
                if let steamID = steamAuth.steamID {
                    UserDefaults.standard.set(steamID, forKey: "steamID")
                    DispatchQueue.main.async {
                        // aggiorna UI o logica se serve
                    }
                } else {
                    print("⚠️ No Steam ID available yet")
                }
            }

        }, label: {
            HStack (alignment: .center){
                Image(icon)
                    .resizable()
                    .frame(width: 25, height: 25)
                Text("Connect to \(text)")
                    .font(.helvetica(fontStyle: .title3, fontWeight: .bold))
                    .foregroundColor(.text)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            .background(.buttonBackground)
            .cornerRadius(10)
        })
        .padding(.horizontal, 20)
    }
}

#Preview {
    PlatformButton(icon: "xbox", text: "Xbox")
}
