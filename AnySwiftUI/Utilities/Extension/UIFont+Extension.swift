//
//  UIFont+Extension.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 10/02/26.
//

import SwiftUI

extension Font {
    
    enum FontSize: CGFloat {
        case footNote = 9
        case note = 10
        case caption = 11
        case description = 12
        case subtitle = 14
        case row = 15
        case title = 16
        case toolBarTitle = 17
        case largeTitle = 18
        case headLine = 20
        case midHeadLine = 22
        case largeHeadLine = 24
        case heavyLarge = 30
        
        var value: CGFloat {
            return self.rawValue
        }
    }
    
    enum ARFonts {
        
        case light
        case regular
        case medium
        case semibold
        case bold
        
        func getFont(_ type:ARFonts,size: CGFloat) -> Font {
            switch type {
            case .light:
                Font.custom("Avenir-Light", size: size)
            case .regular:
                Font.custom("Avenir-Book", size: size)
            case .medium:
                Font.custom("Avenir-Medium", size: size)
            case .semibold:
                Font.custom("Avenir-Heavy", size: size)
            case .bold:
                Font.custom("Avenir-Black", size: size)
            }
        }
    }
    
    static func light(_ size:FontSize) -> Font{
        ARFonts.light.getFont(.light, size: size.value)
    }
    
    static func regular(_ size:FontSize) -> Font {
        ARFonts.regular.getFont(.regular, size: size.value)
    }
    
    static func medium(_ size:FontSize) -> Font {
        ARFonts.medium.getFont(.medium, size: size.value)
    }
    
    static func semibold(_ size:FontSize) -> Font {
        ARFonts.semibold.getFont(.semibold, size: size.value)
    }
    
    static func bold(_ size:FontSize) -> Font {
        ARFonts.bold.getFont(.bold, size: size.value)
    }
}
