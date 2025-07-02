import SwiftUI

struct GameDetails: View {
    var viewModel: SteamGameViewModel
    var gameID: Int
    
    @State private var gameDetails: SteamGameViewModel.SteamDetailedData?
    @State private var isLoading = true
    
    @State private var isDescriptionExpanded = false
    
    // colonne dinamiche per le card degli achivments(in base alla larghezza dello schermo)
    let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 10)
    ]

    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea(.all)
        
            ScrollView {
                if isLoading {
                    ProgressView("Loading...")
                        .padding()
                } else if let details = gameDetails {
                    VStack(alignment: .leading, spacing: 16) {
                        if let url = URL(string: details.headerImage) {
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
                                        .aspectRatio(16.0/9.0, contentMode: .fill)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .clipped()
                                        .cornerRadius(12)
                                        .shadow(color: .shadow, radius: 8, x: 0, y: 4)
                                        .edgesIgnoringSafeArea(.horizontal)
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

                        HStack{
                            Text(details.name)
                                .font(.helvetica(fontStyle: .title2, fontWeight: .bold))
                                .foregroundColor(.text)
                            Spacer()
                            Text("Steam")
                                .font(.helvetica(fontStyle: .headline, fontWeight: .bold))
                                .foregroundColor(.accent)
                        }
                        //Description
                        if !details.detailedDescription.htmlToPlainTextFiltered.isEmpty {
                            Text("Description:")
                                .font(.helvetica(fontStyle: .title3, fontWeight: .bold))
                                .foregroundColor(.text)
                            
                            // Dividi in paragrafi
                            let paragraphs = details.detailedDescription.htmlToPlainTextFiltered.components(separatedBy: "\n")
                            
                            // Testo da mostrare a seconda di isDescriptionExpanded
                            let textToShow = isDescriptionExpanded ? paragraphs.joined(separator: "\n") : paragraphs.prefix(3).joined(separator: "\n")
                            
                            Text(textToShow)
                                .font(.helvetica(fontStyle: .body, fontWeight: .regular))
                                .foregroundColor(.text)
                            
                            // Pulsante per mostrare o nascondere il resto
                            if paragraphs.count > 3 {
                                HStack{
                                    Spacer()
                                    Button(action: {
                                        withAnimation {
                                            isDescriptionExpanded.toggle()
                                        }
                                    }) {
                                        Text(isDescriptionExpanded ? "Show less" : "Show more")
                                            .font(.helvetica(fontStyle: .body, fontWeight: .semibold))
                                            .foregroundColor(.accentColor)
                                    }
                                    .padding(.top, 4)
                                }
                            }
                        }
                        
                        //Achivment
                        
                        if !details.achievements.isEmpty{
                            Text("Achivments of this games:")
                                .font(.helvetica(fontStyle: .title2, fontWeight: .bold))
                                .foregroundColor(.text)
                            LazyVGrid(columns: columns, spacing: 16){
                                ForEach(details.achievements) { achievement in
                                    AchivmentCard(title: achievement.name ?? "Unknown", imgUrl: achievement.path ?? "")
                                    }
                            }
                        }
                        
                    }//END VStack
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
    }//End Body
}

#Preview {
    GameDetails(viewModel: SteamGameViewModel(), gameID: 620)
}
