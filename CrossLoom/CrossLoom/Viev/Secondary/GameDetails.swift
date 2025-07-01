import SwiftUI

struct GameDetails: View {
    var viewModel: SteamGameViewModel
    var gameID: Int
    
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea(.all)
            ScrollView(.vertical){
                VStack(alignment: .leading) {
                    ZStack(alignment: .top) {
                        if let urlString = viewModel.detailsGame?.headerImage, let url = URL(string: urlString) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty, .failure(_):
                                    ZStack {
                                        Color.gray.opacity(0.1)
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle())
                                    }
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .padding(.top, 10)
                                @unknown default:
                                    ZStack {
                                        Color.gray.opacity(0.1)
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle())
                                    }
                                }
                            }
                        } else {
                            ZStack {
                                Color.gray.opacity(0.1)
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            }
                        }
                    }//End ZStacks for image
                    Text("\(viewModel.detailsGame?.name ?? "No game loaded")" ?? "No game loaded")
                        .font(.helvetica(fontStyle: .headline, fontWeight: .bold))
                        .lineLimit(1)
                        .foregroundColor(.text)

                    Text("\(viewModel.detailsGame?.AchievementNames)")
                }//END VStack
                .padding()
            }//END ScrolView
        }//END ZStacks
        .onAppear {
            Task {
                await viewModel.initializeDetails(id: gameID)
            }
        }
    }//END BODY
}//END struct


#Preview {
    GameDetails(viewModel: SteamGameViewModel(), gameID: 260)
}

