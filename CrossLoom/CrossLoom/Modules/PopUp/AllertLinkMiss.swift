import SwiftUI

struct AllertLinkMiss: View {
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.background.opacity(0.7))
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.ultraThinMaterial)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.accent, lineWidth: 1)
                )
                .shadow(color: .shadow.opacity(0.6), radius: 4, x: 2, y: 4)
                .frame(height: 250)

            VStack {
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
        .frame(height: 250)
        .padding(.horizontal)
    }
}

#Preview {
    AllertLinkMiss()
}
