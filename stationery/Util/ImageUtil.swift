//
//  ImageUtil.swift
//  stationery
//
//  Created by Codigo NOL on 24/12/2020.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(_ urlString: String, bgColor: UIColor? = nil, completed: ((_ success: Bool) -> Void)? = nil) {
        
        if urlString.isEmpty {
            self.image = nil
            self.backgroundColor = bgColor ?? Color.Gray.instance()
            completed?(false)
            return
        }
        
        let string = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: string) {
            self.backgroundColor = bgColor ?? .white
            self.kf.setImage(with: url, completionHandler:  { result in
                switch result {
                case .success: completed?(true)
                case .failure: completed?(false)
                }
            })
        } else {
            self.image = nil
            self.backgroundColor = bgColor ?? Color.Gray.instance()
            completed?(false)
        }
    }
    
}
