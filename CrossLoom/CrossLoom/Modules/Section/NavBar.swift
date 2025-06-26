import SwiftUI

struct NavBar: View {
    
    @StateObject var manager = UserManager()
    
    var body: some View {
        HStack{
            
            NavigationLink(destination: ProfileView()){
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
            }
            .environmentObject(manager)
            //Username
            VStack(alignment: .leading, spacing: 10){
                Text(manager.user.username)
                    .font(.adlam(fontStyle: .headline, fontWeight: .regular))
                    .foregroundColor(.text)
                // Piattaforme collegate
                if manager.user.linkedPlatforms.isEmpty {
                    Text("No Platform")
                        .font(.helvetica(fontStyle: .subheadline, fontWeight: .semibold))
                        .foregroundColor(.buttonBackground)
                } else {
                    HStack {
                        ForEach(manager.user.linkedPlatforms, id: \.self) { item in
                            Text(item.displayName)
                                .font(.helvetica(fontStyle: .subheadline, fontWeight: .semibold))
                                .foregroundColor(.buttonBackground)
                        }
                    }
                }
                Spacer()
            }//END VSTACK
            
            //Button collegamento
            Spacer()
            
            NavigationLink(destination: Linking(platform: manager.user.linkedPlatforms)) {
                VStack{
                    ZStack{
                        Circle()
                            .fill(.buttonBackground)
                            .frame(width: 50, height: 50)
                        Image(systemName: "link")
                            .foregroundColor(.text)
                            .font(.system(size: 24))
                            .shadow(color: .background, radius: 2, x: 2, y: 2)
                    }
                    .shadow(color: .shadow.opacity(0.6), radius: 2, x: 1, y: 1)
                    Spacer()
                }
                .frame(height: 100)
            }
            
            
        }//END HSTACK
        .frame(height: 80)
        .padding(10)
    }
}

#Preview {
    NavigationStack {
        NavBar()
    }
}
