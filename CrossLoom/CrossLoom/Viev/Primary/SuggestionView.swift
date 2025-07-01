import SwiftUI

struct SuggestionView: View {
    
    var viewModel: SteamGameViewModel
    
    // colonne dinamiche per le card(in base alla larghezza dello schermo)
    let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 10)
    ]
    
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea(.all)
            ScrollView(.vertical){
                VStack{
                    Text("Some Suggestions For You")
                        .font(.helvetica(fontStyle: .title, fontWeight: .bold))
                        .foregroundColor(.text)
                        .padding()
                        .multilineTextAlignment(.center)
                    
                    //Stampo le card dei giochi consigliati
                    LazyVGrid(columns: columns, spacing: 16){
                        ForEach(viewModel.suggestedGames) { game in
                            card(for: game)
                        }
                    }
                }//END VStack
            }//END ScrollView
        }//END ZStack
    }//END Body
    
    @ViewBuilder
    func card(for game: SuggestedGame) -> some View {
        GameCard(
            name: game.name,
            subText: "Rating",
            hour: Int(game.rating),
            urlCover: game.thumbnail
        )
        .shadow(color: .shadow, radius: 6, x: 2, y: 4)
    }
    
}

#Preview {
    SuggestionView(viewModel: SteamGameViewModel())
}
