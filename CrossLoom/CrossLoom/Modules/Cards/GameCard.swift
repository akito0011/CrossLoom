import SwiftUI

struct GameCard: View {
    let name: String
    let hour: Int
    let urlCover: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            GeometryReader { geo in
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.1))

                    if let urlString = urlCover, let url = URL(string: urlString) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geo.size.width, height: geo.size.width * 0.6)
                                    .clipped()
                                    .cornerRadius(12)
                            case .failure(_):
                                errorPlaceholder
                            @unknown default:
                                errorPlaceholder
                            }
                        }
                    } else {
                        errorPlaceholder
                    }
                }
            }
            .aspectRatio(1.7, contentMode: .fit) // aspect ratio per avere altezza dinamica coerente

            Text(name)
                .font(.headline)
                .lineLimit(1)

            Text("Hours: \(hour)")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
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
