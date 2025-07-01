import SwiftUI
import AVFoundation


struct ProfileView: View {
    
    @EnvironmentObject var manager: UserManager
    
    @EnvironmentObject var steamAuthManager: SteamAuthManager
    
    @State private var showAlert = false
    @State private var selectedPlatform: Platform?
    
    @State private var player: AVAudioPlayer?
    @State private var hiddenSfx: String = "quack"
    
    var viewModel: SteamGameViewModel
    
    var body: some View {
        NavigationStack {
            ZStack{
                Color.background.ignoresSafeArea(.all)
                
                ScrollView(.vertical){
                    VStack(alignment: .leading, spacing: 20){
                        HStack{
                            //Caricamento dell'immagine utente
                            if let uiImage = UIImage(contentsOfFile: FileManager.default
                                .urls(for: .documentDirectory, in: .userDomainMask)[0]
                                .appendingPathComponent(manager.user.imgURL).path) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                            } else {
                                Image("profile")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                    .onTapGesture{
                                        playSound(soundName: hiddenSfx)
                                    }
                            }
                            VStack(alignment: .leading,spacing: 15){
                                Text(manager.user.username)
                                    .foregroundColor(.text)
                                    .font(.custom("ADLam Display", size: 24))
                                //Piattaforme collegate
                                if manager.user.linkedPlatforms.isEmpty{
                                    Text("No Platform")
                                        .font(.helvetica(fontStyle: .subheadline, fontWeight: .semibold))
                                        .foregroundColor(.text)
                                }else{
                                    HStack{
                                        ForEach(manager.user.linkedPlatforms, id: \.self) { item in
                                            Text(item.displayName)
                                                .font(.helvetica(fontStyle: .subheadline, fontWeight: .semibold))
                                                .foregroundColor(.buttonBackground)
                                        }
                                    }
                                }
                                Spacer()
                            }
                            .frame(height: 80)
                            .padding(.horizontal, 15)
                        }//END HStack
                        
                        
                        InfoCard(viewModel: viewModel)
                        
                        if(!manager.user.linkedPlatforms.isEmpty){
                            Text("Piattaforme:")
                                .foregroundColor(.text)
                                .font(.helvetica(fontStyle: .title2, fontWeight: .bold))
                        }
                        
                        HStack {
                            ForEach(manager.user.linkedPlatforms, id: \.self) { item in
                                Text(item.displayName)
                                    .font(.helvetica(fontStyle: .headline, fontWeight: .semibold))
                                    .foregroundColor(.buttonBackground)

                                Spacer()

                                Button(action: {
                                    selectedPlatform = item
                                    showAlert = true
                                }) {
                                    Image(systemName: "inset.filled.leadinghalf.arrow.leading.rectangle")
                                    Text("Log-Out")
                                }
                                .foregroundColor(.red)
                            }
                        }
                        
                        Spacer()
                    }//END VStack
                    .padding(.horizontal, 15)
                    .confirmationDialog("Are you sure to disconnect your account?", isPresented: $showAlert, titleVisibility: .visible) {
                        Button("Yes", role: .destructive) {
                            if let item = selectedPlatform {
                                if item == .steam {
                                    UserDefaults.standard.removeObject(forKey: "steamID")
                                }
                                steamAuthManager.loginSuccess = false

                                var updatedUser = manager.user
                                updatedUser.linkedPlatforms.removeAll { $0 == item }
                                manager.user = updatedUser
                                manager.save()
                            }
                        }
                        Button("No", role: .cancel) {}
                    }
                }//End ScrollView
            }//END ZSTACK
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ModifiedProfileView()) {
                        Text("Modify")
                            .foregroundColor(.accent)
                            .font(.helvetica(fontStyle: .headline, fontWeight: .semibold))
                    }
                }
            }
        }
    }//END Body
    func playSound(soundName: String) {
        guard let url = Bundle.main.url(forResource: "quack", withExtension: "wav") else {
            print("Audio file not found")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Failed to play sound: \(error)")
        }
    }

}//END Struct

#Preview {
    ProfileView(viewModel: SteamGameViewModel())
        .environmentObject(UserManager())
}
