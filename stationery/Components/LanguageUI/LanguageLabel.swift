//
//  LanguageLabel.swift
//  stationery
//
//  Created by Codigo NOL on 17/01/2021.
//

import UIKit

public class LanguageLabel: UILabel {
    
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
    
    fileprivate func setText(_ title: String?, lan: Language) {
        if let t = title { self.text = t }
        else { self.text = lan == .myanmar ? self.textMyanmar : self.textEnglish }
    }
    
    public func changeLanguage(_ lan: Language, title: String? = nil, withAni: Bool = true) {
        if !(self.text?.removeAllSpaces() ?? "").isEmpty {
            if let t = title, t == self.text { return }
            else {
                let newText = lan == .myanmar ? self.textMyanmar : self.textEnglish
                if self.text == newText { return }
            }
        }
        
        self.font = lan == .myanmar ? getFontMM(fontMm).of(size: fontSizeMm) : getFontEng(fontEng).of(size: fontSizeEng)
        if withAni {
            UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromBottom, animations: {
                self.setText(title, lan: lan)
            }, completion: nil)
        } else {
            setText(title, lan: lan)
        }
        
    }
    
    public func changeLanguage(att lan: Language, title: NSAttributedString? = nil) {
        if !(self.text?.removeAllSpaces() ?? "").isEmpty {
            if let t = title, t == self.attributedText { return }
        }
        
        self.font = lan == .myanmar ? getFontMM(fontMm).of(size: fontSizeMm) : getFontEng(fontEng).of(size: fontSizeEng)
        UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromBottom, animations: {
            self.attributedText = title
        }, completion: nil)
    }
}
