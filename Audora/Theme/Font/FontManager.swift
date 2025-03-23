//
//  FontManager.swift
//  Audora
//
//  Created by Rivaldo Fernandes on 23/03/25.
//

import SwiftUI



extension Font {
    static func custom(_ type: CustomFont, size: CGFloat, weight: CustomWeight = .regular, style: CustomFontStyle = .normal) -> Font {
        
        if weight == .regular && style.rawValue.isEmpty {
            return Font.custom("\(type.rawValue)-Regular", size: size)
        }
        
        let fontFileName = "\(type.rawValue)-\(weight.rawValue)\(style.rawValue)"
        return Font.custom(fontFileName, size: size)
    }
}

enum CustomFont: String {
    case rubik = "Rubik"
}

enum CustomFontStyle: String {
    case normal = ""
    case italic = "Italic"
}

enum CustomWeight: String {
    case black = "Black"
    case bold = "Bold"
    case extraBold = "ExtraBold"
    case light = "Light"
    case medium = "Medium"
    case regular = ""
    case semiBold = "SemiBold"
}
