import SwiftUI

struct suggestionGameCard: View {
    
    let name: String
    let subText: String
    let gender: [String]?
    let urlCover: String?
    
    @State private var cardHeight: CGFloat = 180
    @State private var cardWidth: CGFloat = 240
    
    var body: some View {
        ZStack(alignment: .bottom){
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
                            .aspectRatio(16.0/9.0, contentMode: .fill)
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
                HStack {
                    Text("\(subText):")
                    Text(gender?.joined(separator: ", ") ?? "")
                }
                .font(.helvetica(fontStyle: .subheadline, fontWeight: .regular))
                .foregroundColor(.text)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color.background)
            
        }//END ZStack
        .frame(width: cardWidth, height: cardHeight)
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding(8)
    }
}

#Preview {
    suggestionGameCard(name: "Cuphead The Delicious Last Course Edge", subText: "Category", gender: ["Hard", "Animate Cartoon", "Co-op", "Platform", "2D"], urlCover: "https://is.gd/TJiNrP")
}
