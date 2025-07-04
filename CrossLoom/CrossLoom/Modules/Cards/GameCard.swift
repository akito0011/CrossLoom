import SwiftUI

struct GameCard: View {
    let name: String
    let subText: String
    let hour: Int
    let urlCover: String?
    
    @State private var cardHeight: CGFloat = 240
    @State private var cardWidth: CGFloat = 160

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if let urlString = urlCover, let url = URL(string: urlString) {
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
                            .aspectRatio(contentMode: .fill)
                            .frame(width: cardWidth, height: cardHeight, alignment: .center)
                            .clipped()
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

            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.helvetica(fontStyle: .headline, fontWeight: .bold))
                    .lineLimit(1)
                    .foregroundColor(.text)
                Text("\(subText): \(hour)")
                    .font(.helvetica(fontStyle: .subheadline, fontWeight: .regular))
                    .foregroundColor(.text)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(.ultraThinMaterial)
            
            Image("Steam_icon")
                .resizable()
                .frame(width: 30, height: 30)
                .padding(.trailing, 10)
                .padding(.bottom, 5)
        }
        .frame(width: cardWidth, height: cardHeight)
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding(8)
    }
}

#Preview {
    GameCard(name: "The Witcher: ....", subText: "Hour", hour: 400, urlCover: "https://is.gd/llju5T")
        
}
