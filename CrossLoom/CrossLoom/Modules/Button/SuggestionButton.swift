import SwiftUI

struct SuggestionButton: View {
    
    var viewModel: SteamGameViewModel
    
    var body: some View {
        NavigationLink(destination: SuggestionView(viewModel: viewModel)) {
            ZStack{
                RoundedRectangle(cornerRadius: 15)
                    .fill(.buttonBackground)
                    .frame(height: 80)
                HStack{
                    Text("Watch Your Suggestion Games")
                        .foregroundColor(.text)
                        .font(.helvetica(fontStyle: .headline, fontWeight: .bold))
                    Image(systemName: "lightbulb.max.fill")
                        .foregroundColor(.text)
                        .font(.system(size: 22))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            .shadow(color: .shadow.opacity(0.6), radius: 4, x: 2, y: 2)
        }
    }
}

#Preview {
    SuggestionButton(viewModel: SteamGameViewModel())
}
