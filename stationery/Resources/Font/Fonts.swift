//
//  Fonts.swift
//  DogDirectory
//
//  Created by Nay Oo Linn on 04/12/2020.
//
import Foundation
import UIKit

public enum Font: String {
    
    case Black = "Lato-Black"
    case BlackItalic = "Lato-BlackItalic"
    case Bold = "Lato-Bold"
    case BoldItalic = "Lato-BoldItalic"
    case Italic = "Lato-Italic"
    case Light = "Lato-Light"
    case LightItalic = "Lato-LightItalic"
    case Regular = "Lato-Regular"
    case MMRegular = "Pyidaungsu"
    case MMBold = "Pyidaungsu-Bold"
    
    public func of(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
}


public extension UIFont {
    
    // load framework font in application
    static func loadAllFonts() {
        registerFontWith(filename: "Lato-Black.ttf")
        registerFontWith(filename: "Lato-BlackItalic.ttf")
        registerFontWith(filename: "Lato-Bold.ttf")
        registerFontWith(filename: "Lato-BoldItalic.ttf")
        registerFontWith(filename: "Lato-Italic.ttf")
        registerFontWith(filename: "Lato-Light.ttf")
        registerFontWith(filename: "Lato-LightItalic.ttf")
        registerFontWith(filename: "Lato-Regular.ttf")
        registerFontWith(filename: "Pyidaungsu-1.8.3_Regular.ttf")
        registerFontWith(filename: "Pyidaungsu-1.8.3_Bold.ttf")
    }
    
    //MARK: - Make custom font bundle register to framework
    static func registerFontWith(filename: String) {
        let bundle = Bundle.main
        guard let pathForResourceString = bundle.path(forResource: filename, ofType: nil) else {
            print("Failed to register font \(filename) - nil pathForResourceString")
            return
        }
        guard let fontData = NSData(contentsOfFile: pathForResourceString), let dataProvider = CGDataProvider.init(data: fontData) else {
            print("Failed to register font \(filename) - nil fontData/ dataProvider")
            return
        }
        guard let fontRef = CGFont.init(dataProvider) else {
            print("Failed to register font \(filename) - nil fontRef")
            return
        }
        
        var errorRef: Unmanaged<CFError>? = nil
        if (CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) == false) {
            print("Failed to register font \(filename) - register graphics font failed - this font may have already been registered in the main bundle.")
        }
    }
}
