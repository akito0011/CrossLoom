import SwiftUI

struct SuggestionView: View {
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
                    Spacer()
                }//END VStack
            }//END ScrollView
        }//END ZStack
    }//END Body
}

#Preview {
    SuggestionView()
}
