import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var manager: UserManager
    
    @EnvironmentObject var steamAuthManager: SteamAuthManager
    
    var body: some View {
        NavigationStack {
            ZStack{
                Color.background.ignoresSafeArea(.all)
                
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
                    
                    InfoCard()
                    
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
                            
                            Button(action:{
                                if item == .steam {
                                    UserDefaults.standard.removeObject(forKey: "steamID")
                                }
                                steamAuthManager.loginSuccess = false
                                
                                var updatedUser = manager.user
                                updatedUser.linkedPlatforms.removeAll { $0 == item }
                                manager.user = updatedUser
                                manager.save()
                            },label:{
                                Image(systemName: "inset.filled.leadinghalf.arrow.leading.rectangle")
                                Text("Log-Out")
                            })
                            .foregroundColor(.red)
                        }
                    }
                    
                    Spacer()
                }//END VStack
                .padding(.horizontal, 15)
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
    }
}

#Preview {
    ProfileView()
        .environmentObject(UserManager())
}
