//  
//  ProfileRouter.swift
//  stationery
//
//  Created by Codigo NOL on 20/12/2020.
//

import Foundation

@objc protocol ProfileRoutingLogic {
    func routeToEditProfile()
    func routeToOrders()
    func routeToContactUs()
    func routeToAboutUs()
}

class ProfileRouter: NSObject, ProfileRoutingLogic {
    
    weak var viewController: ProfileVC?
    
    // MARK: routing
    func routeToEditProfile() {
        viewController?.navigationController?.pushViewController(EditProfileVC.instantiate(), animated: true)
    }
    
    func routeToOrders() {
        viewController?.navigationController?.pushViewController(OrderHistoryVC.instantiate(), animated: true)
    }
    
    func routeToContactUs() {
        viewController?.navigationController?.pushViewController(ContactUsVC.instantiate(), animated: true)
    }
    
    func routeToAboutUs() {
        viewController?.navigationController?.pushViewController(AboutVC.instantiate(), animated: true)
    }
}
