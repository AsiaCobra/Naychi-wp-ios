//
//  UILable.swift
//  CommonExtension
//
//  Created by Codigo NOL on 06/12/2020.
//

import UIKit

public extension UILabel {
    
    func changeTextWithAni(_ text: String?, option: UIView.AnimationOptions = .transitionCrossDissolve) {
        UIView.transition(with: self, duration: 0.2, options: option, animations: {
            self.text = text
        }, completion: nil)
    }
    
    func highlightPartOf(_ text:String, normalColor:UIColor, normalFont: UIFont, highlightText:[String], highlightColor:UIColor, highlightFont: UIFont, lineSpacing:CGFloat = 1) {
        
        self.numberOfLines = 0
        
        let nsString = text as NSString
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineSpacing
        paragraphStyle.alignment = self.textAlignment
        
        let attributedString = NSMutableAttributedString(string: text, attributes: [
            .paragraphStyle: paragraphStyle,
            .font: normalFont,
            .foregroundColor: normalColor
        ])
        
        var highlightRanges: [NSRange] = []
        for highlight in highlightText {
            let range = nsString.range(of: highlight)
            attributedString.addAttributes([
                .foregroundColor: highlightColor,
                .font: highlightFont,
            ], range: range)
            highlightRanges.append(range)
        }
        self.attributedText = attributedString;
    }
}
