import SwiftUI

struct Linking: View {

    @EnvironmentObject var manager: UserManager
    @EnvironmentObject var steamAuthManager: SteamAuthManager

    @Environment(\.dismiss) var dismiss
    @State private var showSuccessAlert = false

    let allPlatforms = Platform.allCases

    var body: some View {
        let platformsUnlinked = allPlatforms.filter { !manager.user.linkedPlatforms.contains($0) }
        ZStack{
            Color.background.ignoresSafeArea(.all)
            ScrollView(.vertical){
                VStack(spacing: 25){
                    Text("Collegati alla tua piattaforma di gioco")
                        .foregroundColor(.text)
                        .font(.helvetica(fontStyle: .title, fontWeight: .bold))
                        .multilineTextAlignment(.center)

                    if manager.user.linkedPlatforms == allPlatforms {
                        Text("Hai già collegato tutte le piattaforme!")
                            .foregroundColor(.gray)
                            .font(.helvetica(fontStyle: .subheadline, fontWeight: .regular))
                    } else {
                        ForEach(platformsUnlinked, id: \.self) { item in
                            PlatformButton(icon: item.displayName.lowercased(), text: item.displayName)
                        }
                    }
                    AllertLinkMiss()
                    Spacer()
                }//END VSTACK
                .frame(maxWidth: .infinity)
            }
        }
        .onChange(of: steamAuthManager.loginSuccess) { success in
            if success {
                showSuccessAlert = true
            }
        }
        .alert("Accesso riuscito!", isPresented: $showSuccessAlert) {
            Button("OK") {
                dismiss()
                
            }
        }
    }
}

#Preview {
    Linking()
        .environmentObject(UserManager())
        .environmentObject(SteamAuthManager())
}
