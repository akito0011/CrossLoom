import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea(.all)
            VStack {
                HStack(spacing: 10){
                    GameCard(name: "Apex Legends", hour: 10020, urlCover: "https://is.gd/HM0Xaj")
                    GameCard(name: "League Of Legends", hour: 100, urlCover: "https://is.gd/xADE5c")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
