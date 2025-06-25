import SwiftUI

struct NavBar: View {
    
    @State var username: String
    @State var imgUrl: String
    
    @State var platform: [Platform]
    
    var body: some View {
        HStack{
            
            //Caricamento dell'immagine utente
            
            if imgUrl == "profile" {
                Image("profile")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
            } else if let url = URL(string: imgUrl) {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    } else if phase.error != nil {
                        // Errore nel caricamento
                        Image("profile") // fallback
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    } else {
                        ProgressView() // caricamento in corso
                    }
                }
            }
            //Username
            VStack(alignment: .leading, spacing: 10){
                Text(username)
                    .font(.adlam(fontStyle: .headline, fontWeight: .regular))
                    .foregroundColor(.text)
                //Piattaforme collegate
                if platform.isEmpty{
                    Text("No Platform")
                        .font(.helvetica(fontStyle: .subheadline, fontWeight: .semibold))
                        .foregroundColor(.buttonBackground)
                }else{
                    HStack{
                        ForEach(platform, id: \.self) { item in
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
            
            NavigationLink(destination: Linking(platform: platform)) {
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
        NavBar(username: "Username101", imgUrl: "profile", platform: [])
    }
}
