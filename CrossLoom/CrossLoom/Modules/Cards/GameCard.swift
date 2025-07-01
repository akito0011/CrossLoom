import SwiftUI

struct GameCard: View {
    let name: String
    let hour: Int
    let urlCover: String?
    
    @State private var cardHeight: CGFloat = 240
    @State private var cardWidth: CGFloat = 160

    var body: some View {
        ZStack(alignment: .bottom) {
            if let urlString = urlCover, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: cardWidth, height: cardHeight)
                            .clipped()
                    case .failure(_):
                        errorPlaceholder
                    @unknown default:
                        errorPlaceholder
                    }
                }
            } else {
                errorPlaceholder
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.headline)
                    .lineLimit(1)
                    .foregroundColor(.text)
                Text("Hours: \(hour)")
                    .font(.subheadline)
                    .foregroundColor(.text)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(.ultraThinMaterial)
        }
        .frame(width: cardWidth, height: cardHeight)
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding(8)
    }

    private var errorPlaceholder: some View {
        VStack {
            Image(systemName: "xmark.octagon.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .foregroundColor(.red)
            Text("Errore immagine")
                .font(.caption)
                .foregroundColor(.red)
        }
    }
}

#Preview {
    GameCard(name: "Apex", hour: 400, urlCover: "https://is.gd/llju5T")
        
}
