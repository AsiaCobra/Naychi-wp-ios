//
//  UIStoryboard.swift
//  CommonExtension
//
//  Created by Codigo Kaung Soe on 06/12/2019.
//  Copyright © 2019 codigo. All rights reserved.
//

import UIKit

public protocol Storyboarded {
    static var storyboardName: String { get set }
    static func instantiate(from bundle: Bundle) -> Self
}

extension Storyboarded where Self: UIViewController {
    public static func instantiate(from bundle: Bundle = Bundle.main) -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: Self.className) as! Self
    }
    
    public static func instantiateWithNavi(from bundle: Bundle = Bundle.main) -> UINavigationController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: Self.className) as! Self
        let nav = UINavigationController(rootViewController: vc)
        nav.isNavigationBarHidden = true
        nav.hidesBottomBarWhenPushed = true
        nav.interactivePopGestureRecognizer?.delegate = nil
        return nav
    }
}
