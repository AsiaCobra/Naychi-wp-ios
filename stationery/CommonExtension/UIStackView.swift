//
//  UIStackView.swift
//  CommonExtension
//
//  Created by Codigo NOL on 06/12/2020.
//

import UIKit

public extension UIStackView {
    @discardableResult func removeAllArrangedSubviews() -> [UIView] {
        let removedSubviews = arrangedSubviews.reduce([]) { (removedSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            NSLayoutConstraint.deactivate(subview.constraints)
            subview.removeFromSuperview()
            return removedSubviews + [subview]
        }
        return removedSubviews
    }
    
    @discardableResult
    func removeAllArrangedSubviews(except view: UIView) -> [UIView] {
        let removedSubviews = arrangedSubviews.reduce([]) { (removedSubviews, subview) -> [UIView] in
            if subview == view {
                return removedSubviews
            }
            removeArrangedSubview(subview)
            NSLayoutConstraint.deactivate(subview.constraints)
            subview.removeFromSuperview()
            return removedSubviews + [subview]
        }
        return removedSubviews
    }

}
