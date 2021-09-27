//
//  UINavigationController.swift
//  Isetan
//
//  Created by Nay Oo Linn on 5/8/19.
//  Copyright © 2019 codigo. All rights reserved.
//

import UIKit

extension UINavigationController {
    func pushFromBottom(_ viewControllerToPush: UIViewController) {
        let transition: CATransition = CATransition()
        transition.duration = 0.25
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        DispatchQueue.main.async {
            self.view.window!.layer.add(transition, forKey: kCATransition)
            self.pushViewController(viewControllerToPush, animated: false)
        }
    }
    
    func popToBottom() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        DispatchQueue.main.async {
            self.view.window!.layer.add(transition, forKey: kCATransition)
            self.popViewController(animated: false)
        }
    }
}
