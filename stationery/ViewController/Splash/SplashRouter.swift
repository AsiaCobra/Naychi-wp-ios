//  
//  SplashRouter.swift
//  stationery
//
//  Created by Codigo NOL on 20/12/2020.
//

import UIKit
import DrawerMenu

@objc protocol SplashRoutingLogic {
	 func routeToApp()
}

class SplashRouter: NSObject, SplashRoutingLogic {
    
    weak var viewController: SplashVC?
    
    // MARK: routing
     func routeToApp() {
        let menu = DrawerMenu(center: TabbarVC.instantiate(), left: MenuVC.instantiateWithNavi())
        menu.panGestureType = .pan
        menu.style = Overlay()
        menu.view.layer.shadowOpacity = 0.0

        // show with animation
        let window = UIApplication.shared.keyWindow
        UIView.transition(with: window!, duration: 0.5, options: .transitionFlipFromRight, animations: {
            window?.rootViewController = menu
        }, completion: nil)
        
     }
}
