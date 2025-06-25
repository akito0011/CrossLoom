import SwiftUI

struct AllertLinkMiss: View {
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.background)
                .frame(width: .infinity, height: 250)
            VStack{
                Text("Feature in coming")
                    .foregroundColor(.red)
                    .font(.helvetica(fontStyle: .title, fontWeight: .bold))
                    .padding(.top, 15)
                Text("We're working to implement this feature.")
                    .foregroundColor(.text)
                    .font(.helvetica(fontStyle: .body, fontWeight: .semibold))
                    .multilineTextAlignment(.center)
                    .padding(.top, 15)
                
                Spacer()
            }
        }
        .frame(width: .infinity, height: 250)
        .padding(.horizontal)
        .shadow(color: .shadow.opacity(0.6), radius: 2, x: 1, y: 1)
    }
}

#Preview {
    AllertLinkMiss()
}
