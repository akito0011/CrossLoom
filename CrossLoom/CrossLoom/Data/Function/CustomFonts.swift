import SwiftUI

extension Font {
    
//    static func adlam(fontStyle: Font.TextStyle = .body, fontWeight: Weight = .regular) -> Font {
//        return Font.custom("ADLaMDisplay-Regular",size: fontStyle.size)
//    }
    
    static func helvetica(fontStyle: Font.TextStyle = .body, fontWeight: Weight = .regular) -> Font {
        return Font.system(size: fontStyle.size, weight: fontWeight, design: .default)
    }
}

extension Font.TextStyle {
    var size: CGFloat {
        switch self {
        case .largeTitle: return 34
        case .title: return 30
        case .title2: return 22
        case .title3: return 20
        case .headline: return 18
        case .body: return 16
        case .callout: return 15
        case .subheadline: return 14
        @unknown default: return 8
        }
    }
}

//enum AdlamFont: String {
//    case regular = "ADLaMDisplay-Regular"
//    
//    init(weight: Font.Weight) {
//        switch weight {
//        case .regular: self = .regular
//        default: self = .regular
//        }
//    }
//}

enum HelveticaNeue: String {
    case regular = "HelveticaNeue-Regular"
    case bold = "HelveticaNeue-Bold"
    case semibold = "HelveticaNeue-SemiBold"
    case thin = "HelveticaNeue-Thin"

    init(weight: Font.Weight) {
        switch weight {
        case .bold: self = .bold
        case .semibold: self = .semibold
        case .thin: self = .thin
        default: self = .regular
        }
    }
}
