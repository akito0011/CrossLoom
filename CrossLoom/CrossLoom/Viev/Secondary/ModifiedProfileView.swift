import SwiftUI
import PhotosUI

struct ModifiedProfileView: View {
    @EnvironmentObject var manager: UserManager
    @Environment(\.dismiss) var dismiss
    @State private var showAlert = false
    
    @State private var profileImage: UIImage? = nil
    @State private var selectedItem: PhotosPickerItem? = nil
    
    @State private var username: String =  ""
    
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea(.all)
            VStack(spacing: 20) {
                // Immagine profilo
                if let image = profileImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } else {
                    Image("profile")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                }
                
                // Picker per la foto
                PhotosPicker("Choose Picture", selection: $selectedItem, matching: .images)
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                profileImage = uiImage
                                saveImageToDisk(uiImage)
                                manager.user.imgURL = "profile.jpg"
                                manager.save()
                            }
                        }
                    }
                
                // Campo per modificare username
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("SAVE") {
                    manager.user.username = username
                    manager.save()
                    showAlert = true
                }
                .alert("Data Saved", isPresented: $showAlert) {
                    Button("OK") {
                        dismiss()
                    }
                }
                .padding()
            }
            .padding()
            .onAppear {
                self.username = manager.user.username
                if let image = loadImageFromDisk() {
                    profileImage = image
                }
            }
        }
    }
    
    // MARK: - Salvataggio immagine
    func saveImageToDisk(_ image: UIImage) {
        if let data = image.jpegData(compressionQuality: 0.8) {
            let url = getDocumentsDirectory().appendingPathComponent("profile.jpg")
            try? data.write(to: url)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func loadImageFromDisk() -> UIImage? {
        let url = getDocumentsDirectory().appendingPathComponent("profile.jpg")
        return UIImage(contentsOfFile: url.path)
    }
}

#Preview {
    ModifiedProfileView()
        .environmentObject(UserManager())
}
