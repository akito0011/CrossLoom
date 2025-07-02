import SwiftUI

struct AchivmentCard: View {
    
    let title: String
    let imgUrl: String
    
    @State private var cardHeight: CGFloat = 240
    @State private var cardWidth: CGFloat = 160
    
    var body: some View {
        ZStack(alignment: .bottom){
            Color.background
            if let url = URL(string: imgUrl){
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
                            .aspectRatio(contentMode: .fit)
                            .frame(width: cardWidth, height: cardHeight, alignment: .top)
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
            
            VStack{
                Text("\(title)")
                    .font(.helvetica(fontStyle: .headline, fontWeight: .bold))
                    .foregroundColor(.text)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: cardHeight/3)
            .background(Color.background)
            
        }//END ZStack
        .frame(width: cardWidth, height: cardHeight)
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding(8)
    }
}

#Preview {
    AchivmentCard(title: "Taking Names", imgUrl: "https://is.gd/bhMor1")
}
