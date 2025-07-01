import SwiftUI

struct GameDetails: View {
    var viewModel: SteamGameViewModel
    var gameID: Int
    
    @State private var gameDetails: SteamGameViewModel.SteamDetailedData?
    @State private var isLoading = true

    var body: some View {
        ScrollView {
            if isLoading {
                ProgressView("Loading...")
                    .padding()
            } else if let details = gameDetails {
                VStack(alignment: .leading, spacing: 16) {
                    AsyncImage(url: URL(string: details.headerImage)) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(height: 200)
                    .cornerRadius(12)

                    Text(details.name)
                        .font(.title)
                        .bold()

                    Text(details.detailedDescription)
                        .font(.body)
                }
                .padding()
            } else {
                Text("Failed to load game details.")
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            Task {
                isLoading = true
                let details = await viewModel.gameDetailInfo(for: gameID)
                await MainActor.run {
                    self.gameDetails = SteamGameViewModel.SteamDetailedData(from: details)
                    self.isLoading = false
                }
            }
        }
    }
}
