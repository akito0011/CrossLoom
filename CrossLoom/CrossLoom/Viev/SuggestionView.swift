import SwiftUI

struct SuggestionView: View {
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea(.all)
            ScrollView(.vertical){
                VStack{
                    Text("Attacati al ....")
                        .font(.helvetica(fontStyle: .title, fontWeight: .bold))
                        .foregroundColor(.text)
                    Spacer()
                }//END VStack
            }//END ScrollView
        }//END ZStack
    }//END Body
}

#Preview {
    SuggestionView()
}
