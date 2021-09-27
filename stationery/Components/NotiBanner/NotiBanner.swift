//
//  NotiBanner.swift
//  stationery
//
//  Created by Codigo NOL on 10/01/2021.
//

import Foundation
import BRYXBanner

class NotiBanner {
    
    enum ToastType {
        case natural
        case success
        case error
    }
    
    static func toast(_ title: String, icon: String? = nil, type: ToastType = .natural) {
        
        var topNotch: CGFloat {
            if #available(iOS 11.0, tvOS 11.0, *) {
                return UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
            }
            return 0
        }
        
        var bgColor = Color.Red.instance()
        var textColor = UIColor.white
        
        switch type {
        case .natural:
            bgColor = Color.Silver.instance()
            textColor = Color.Black.instance()
        case .success:
            bgColor = Color.JungleGreen.instance()
            textColor = .white
        case .error:
            bgColor = Color.Red.instance()
            textColor = .white
        }
        
        var fullString = NSMutableAttributedString(string: title)
        let font = Font.Bold.of(size: 14)
        if let img = icon, !img.isEmpty {
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(named: img)
            
            if  let imageSize = imageAttachment.image?.size {
                imageAttachment.bounds = CGRect(x: 20, y: (font.capHeight - imageSize.height) / 2, width: imageSize.width, height: imageSize.height)
            }
            
            let image1String = NSAttributedString(attachment: imageAttachment)
            fullString = NSMutableAttributedString(string: "")
            fullString.append(image1String)
            fullString.append(NSAttributedString(string: "  \(title)"))
        }
        
        let banner = Banner(title: "", subtitle: nil, image: nil, backgroundColor: bgColor)
        banner.minimumHeight = 60 + topNotch
        banner.titleLabel.font = font
        banner.titleLabel.textAlignment = .center
        banner.titleLabel.attributedText = fullString
        banner.textColor = textColor
        banner.dismissesOnTap = true
        banner.show(duration: 3.0)
    }
}
