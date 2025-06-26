import SwiftUI

struct Linking: View {
    
    @State var platform: [Platform]
    
    let allPlatforms = Platform.allCases
    
    
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea(.all)
            VStack(spacing: 25){
                Text("Collegati alla tua piattaforma di gioco")
                    .foregroundColor(.text)
                    .font(.helvetica(fontStyle: .title, fontWeight: .bold))
                    .multilineTextAlignment(.center)
                
                
                let unlinkedPlatforms = allPlatforms.filter { !platform.contains($0) }
                
                if unlinkedPlatforms.isEmpty {
                    Text("Hai già collegato tutte le piattaforme!")
                        .foregroundColor(.gray)
                        .font(.helvetica(fontStyle: .subheadline, fontWeight: .regular))
                } else {
                    ForEach(unlinkedPlatforms, id: \.self) { item in
                        PlatformButton(icon: item.displayName.lowercased(), text: item.displayName)
                    }
                }
                AllertLinkMiss()
                Spacer()
            }//END VSTACK
            .frame(maxWidth: .infinity)
        }
    }//END BODY
}

#Preview {
    Linking(platform: [])
}
