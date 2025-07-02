import SwiftUI

struct InfoCard: View {
    
    @EnvironmentObject var manager: UserManager
    
    @ObservedObject var viewModel: SteamGameViewModel
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.background.opacity(0.7))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.accent, lineWidth: 1)
                )
                .shadow(color: .shadow.opacity(0.6), radius: 4, x: 2, y: 4)
                .frame(height: 160)
            if(!manager.user.linkedPlatforms.isEmpty){
                VStack(spacing: 10){
                    HStack(alignment: .center){
                        if let mostPlayedGame = viewModel.games.max(by: { $0.playtime < $1.playtime }) {
                            Text("Most played game:")
                            Spacer()
                            Text("\(mostPlayedGame.name)")
                        }
                    }
                    HStack(alignment: .center) {
                        Text("Total hours of play:")
                        Spacer()
                        Text("\(viewModel.totalPlaytimeHours)")
                    }
                    HStack(alignment: .center){
                        Text("Owned Games:")
                        Spacer()
                        Text("\(viewModel.games.count)")
                        
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
    InfoCard(viewModel: SteamGameViewModel())
        .environmentObject(UserManager())
}
