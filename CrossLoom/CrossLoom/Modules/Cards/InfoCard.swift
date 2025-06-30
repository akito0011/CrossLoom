import SwiftUI

struct InfoCard: View {
    
    @EnvironmentObject var manager: UserManager
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.background.opacity(0.7))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.accent, lineWidth: 1)
                )
                .shadow(color: .shadow.opacity(0.6), radius: 4, x: 2, y: 4)
                .frame(height: 180)
            if(!manager.user.linkedPlatforms.isEmpty){
                VStack(spacing: 10){
                    HStack(alignment: .center){
                        Text("Category most played:")
                        Spacer()
                        Text("Free-To-Play")
                    }
                    HStack(alignment: .center){
                        Text("Game most played:")
                        Spacer()
                        Text("Apex Legends")
                    }
                    HStack(alignment: .center){
                        Text("Totaly hours of play:")
                        Spacer()
                        Text("10240")
                    }
                    HStack(alignment: .center){
                        Text("Owned Games:")
                        Spacer()
                        Text("102")
                    }
                }
                .foregroundColor(.text)
                .font(.helvetica(fontStyle: .headline, fontWeight: .bold))
                .padding(.horizontal, 10)
            }else{
                Text("Connect your platform to see more information!")
                    .foregroundColor(.text)
                    .font(.helvetica(fontStyle: .headline, fontWeight: .bold))
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    InfoCard()
        .environmentObject(UserManager())
}
