import SwiftUI

struct GameCard: View {
    
    @State var name: String
    @State var hour: Int
    @State var urlCover: String
    
    public var widthCard: CGFloat = 160
    public var heightCard: CGFloat = 260
    
    @State private var colorText: Color = Color("CardText")
    
    var body: some View {
        VStack{
            ZStack(alignment: .bottom) {
                AsyncImage(url: URL(string: urlCover)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                    } else if phase.error != nil {
                        ZStack {
                            Color.gray.opacity(0.3)
                            VStack(alignment: .center, spacing: 10) {
                                Image(systemName: "x.circle")
                                    .font(.system(size: 40, weight: .semibold))
                                    .foregroundStyle(Color.red)
                                Text("Errore nel caricamento dell'immagine!")
                                    .font(.helvetica(fontStyle: .subheadline, fontWeight: .regular))
                                    .padding(5)
                                    .foregroundColor(Color.red.opacity(0.5))
                                    .multilineTextAlignment(.center)
                                Spacer()
                            }
                            .padding(.top, 15)
                        }
                        .onAppear{
                            colorText = Color("Text")
                        }
                    }
                }
                .frame(width: widthCard, height: heightCard)
                .clipShape(RoundedRectangle(cornerRadius: 10))

//                // MORPHIUS EFFECT RECTANGLE
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.helvetica(fontStyle: .headline, fontWeight: .bold))
                        .foregroundColor(colorText)
                    Text("Hours: \(hour)")
                        .font(.helvetica(fontStyle: .subheadline, fontWeight: .regular))
                        .foregroundColor(colorText)
                }
                .padding()
                .frame(width: widthCard, height: 80, alignment: .leading)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.bottom, 0)
            }
            .frame(width: widthCard, height: heightCard)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.shadow.opacity(0.6), radius: 4, x: 2, y: 2)
        }
    }//END BODY
}

#Preview {
    GameCard(name: "Apex Legends", hour: 10020, urlCover: "://is.gd/HM0Xaj")
}
