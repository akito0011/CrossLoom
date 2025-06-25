import SwiftUI

struct PlatformButton: View {
    
    @State var icon: String
    @State var text: String
    
    var body: some View {
        Button(action: {
            SteamAuthManager.shared.startSteamLogin { result in
                switch result {
                case .success(let steamID):
                UserDefaults.standard.set(steamID, forKey: "steamID")
                    print("✅ Steam ID: \(steamID)")
                    DispatchQueue.main.async {
                    // aggiorna la lista delle piattaforme collegate
                }
                case .failure(let error):
                    print("❌ Errore Steam login: \(error.localizedDescription)")
                }
            }
        }, label: {
            HStack (alignment: .center){
                Image(icon)
                    .resizable()
                    .frame(width: 25, height: 25)
                Text("Collega \(text)")
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
