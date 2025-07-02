import Foundation

extension String {
    var htmlToPlainTextFiltered: String {
        // Converte HTML in testo semplice
        guard let data = self.data(using: .utf8) else { return self }
        do {
            let attrStr = try NSAttributedString(data: data,
                                                 options: [.documentType: NSAttributedString.DocumentType.html,
                                                           .characterEncoding: String.Encoding.utf8.rawValue],
                                                 documentAttributes: nil)
            let fullText = attrStr.string
            
            // Dividi in paragrafi usando due newline come separatore
            let paragraphs = fullText.components(separatedBy: "\n\n")
            
            // Prendi solo i paragrafi dal 3° in poi (rimuovendo i primi due)
            let filteredParagraphs = paragraphs.dropFirst(2)
            
            // Prendi massimo i primi 3 paragrafi utili
            let finalParagraphs = filteredParagraphs.prefix(3)
            
            // Ricomponi in stringa singola con doppio newline
            return finalParagraphs.joined(separator: "\n\n")
            
        } catch {
            return self
        }
    }
}
