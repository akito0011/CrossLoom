import SwiftUI

struct GameDetails: View {
    var viewModel: SteamGameViewModel
    var gameID: Int
    
    var body: some View {
        VStack {
            Text("\(viewModel.detailsGame?.name ?? "No game loaded")" ?? "No game loaded")
        }
        .onAppear {
            Task {
                await viewModel.initializeDetails(id: gameID)
            }
        }
    }
}


#Preview {
    GameDetails(viewModel: SteamGameViewModel(), gameID: 260)
}

