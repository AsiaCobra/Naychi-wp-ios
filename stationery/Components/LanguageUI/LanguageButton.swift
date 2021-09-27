//
//  LanguageButton.swift
//  stationery
//
//  Created by Codigo NOL on 19/01/2021.
//

import UIKit

class LanguageButton: UIButton {

    @IBInspectable public var textMyanmar: String = "" { didSet { setUpLanguage() } }
    @IBInspectable public var textEnglish: String = "" { didSet { setUpLanguage() } }
    
    @IBInspectable public var fontMm: String = "" { didSet { setUpLanguage() } }
    @IBInspectable public var fontSizeMm: CGFloat = 0 { didSet { setUpLanguage() } }
    
    @IBInspectable public var fontEng: String = "" { didSet { setUpLanguage() } }
    @IBInspectable public var fontSizeEng: CGFloat = 0 { didSet { setUpLanguage() } }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.initView()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    func initView() {
        
    }
    
    func setUp(textMyanmar: String, textEnglish: String, fontMm: String, fontSizeMm: CGFloat, fontEng: String, fontSizeEng: CGFloat) {
        self.textMyanmar = textMyanmar
        self.textEnglish = textEnglish
        self.fontMm = fontMm
        self.fontEng = fontEng
        self.fontSizeMm = fontSizeMm
        self.fontSizeEng = fontSizeEng
    }
    
    func setUp(textMyanmar: String, textEnglish: String) {
        self.textMyanmar = textMyanmar
        self.textEnglish = textEnglish
    }
    
    fileprivate func getFontMM(_ type: String) -> Font {
        return type == "regular" ? Font.MMRegular : Font.MMBold
    }
    
    fileprivate func getFontEng(_ type: String) -> Font {
        switch type {
        case "regular": return Font.Regular
        case "black": return Font.Black
        case "bold": return Font.Bold
        case "light": return Font.Light
        default:  return Font.Regular
        }
    }
    
    fileprivate func setUpLanguage() {
        guard !textMyanmar.isEmpty, !textEnglish.isEmpty, !fontMm.isEmpty, fontSizeMm > 0,
              !fontEng.isEmpty, fontSizeEng > 0 else { return }
        
        changeLanguage(AppUtil.shared.currentLanguage)
    }
    
    public func changeLanguage(_ lan: Language, title: String? = nil) {
        
        self.titleLabel?.font = lan == .myanmar ? getFontMM(fontMm).of(size: fontSizeMm) : getFontEng(fontEng).of(size: fontSizeEng)
        if let t = title {
            self.setTitle(t, for: .normal)
        } else {
            self.setTitle(lan == .myanmar ? textMyanmar : textEnglish, for: .normal)
        }
    }

}
