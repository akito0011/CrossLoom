import SwiftUI

struct RatedGameRow: View {
    let ratedGame: RatedGame

    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: ratedGame.game.urlCover)) { image in
                image.resizable()
                    .scaledToFit()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 80, height: 45)
            .cornerRadius(6)

            VStack(alignment: .leading) {
                Text(ratedGame.game.name)
                    .font(.headline)
                    .lineLimit(1)
                Text("Ore giocate: \(ratedGame.game.playtime)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                StarsView(rating: ratedGame.rating)
            }

            Spacer()
        }
        .padding(.vertical, 8)
    }
}

struct StarsView: View {
    let rating: Int

    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { index in
                Text(index <= rating ? "★" : "☆")
                    .foregroundColor(index <= rating ? .yellow : .gray)
            }
        }
    }
}

struct SteamGamesListView: View {
    @StateObject var viewModel = SteamCombinedViewModel()
    let steamId: String

    var body: some View {
        VStack {
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }

            if viewModel.ratedGames.isEmpty {
                ProgressView("Caricamento giochi...")
                    .onAppear {
                        viewModel.loadData(steamId: steamId)
                    }
            } else {
                List(viewModel.ratedGames) { ratedGame in
                    RatedGameRow(ratedGame: ratedGame)
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle("La tua libreria Steam")
    }
}
