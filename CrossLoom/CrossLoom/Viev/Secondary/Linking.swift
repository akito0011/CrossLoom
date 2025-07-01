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
                    Text("Connect to your gaming platform")
                        .foregroundColor(.text)
                        .font(.helvetica(fontStyle: .title, fontWeight: .bold))
                        .multilineTextAlignment(.center)
                    if manager.user.linkedPlatforms == allPlatforms {
                        Text("You have already connected all platforms!")
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
        .alert("Log in successfully!", isPresented: $showSuccessAlert) {
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
