//
//  BaseVC.swift
//  stationery
//
//  Created by Codigo NOL on 20/12/2020.
//

import UIKit
import DrawerMenu
import SwiftyUserDefaults

class BaseVC: UIViewController {
    
    @IBOutlet weak var mainHeader: MainHeader?
    @IBOutlet weak var mainHeaderHeight: NSLayoutConstraint?
    @IBOutlet weak var navView: NavView?
    @IBOutlet weak var navBar: NavBar?
    
    var navViewHeight: CGFloat = 160
    var drawerMenu: DrawerMenu?
    
    var strechyView: ImageSliderView?
    var strechyViewHeight: CGFloat = 0

    var strechyImageViewTop: NSLayoutConstraint?
    var strechyImageViewHeight: NSLayoutConstraint?
    
    var navBarEffect = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainHeader?.onMusicChange = { [weak self] in self?.navView?.setMusicImage() }
        navView?.onMusicChange = { [weak self] in self?.mainHeader?.setMusicImage() }
        
        mainHeaderHeight?.constant = 102 + self.topSafeArea
        if navBarEffect { navBar?.setEffect(0) }
        navView?.btnMenu.addTarget(self, action: #selector(self.btnMenuTapped), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navView?.setMusicImage()
        mainHeader?.setMusicImage()
    }
    
    func setStrechyView(_ sv: ImageSliderView) {
        self.strechyView = sv
        self.strechyViewHeight = sv.frame.height
    }
    
    func setStrechyView(_ topConstraint: NSLayoutConstraint, _ heightConstraint: NSLayoutConstraint) {
        self.strechyImageViewTop = topConstraint
        self.strechyImageViewHeight = heightConstraint
        self.strechyViewHeight = heightConstraint.constant
    }
    
    @objc func btnMenuTapped() {
        drawer()?.open(to: .left, animated: true, completion: nil)
//        if let menu = UIApplication.shared.topMostViewController as? DrawerMenu {
//            menu.open(to: .left, animated: true, completion: nil)
//        }
    }
    
    func disableDrawerPanGesture() {
        drawer()?.panGestureType = .none
    }
    
    func enableDrawerPanGesture() {
        drawer()?.panGestureType = .pan
    }
    
    func checkUserLogin() -> Bool {
        if !Defaults[key: DefaultsKeys.isUserLogin] {
            var routeToLogin = false
            Dialog.show("", message: "Please Login or Signup to continue.", btnPositiveTitle: "Login/Signup", positiveAction: {
                routeToLogin = true
            }, btnNegativeTitle: "Cancel", didDisappear: {
                if routeToLogin {
                    self.navigationController?.popToRootViewController(animated: false)
                    AppUtil.getTabBar()?.routeTo(screen: .profile)
                }
            })
        }
        
        return Defaults[key: DefaultsKeys.isUserLogin]
    }
    
    func languageCheck(lbls: [LanguageLabel]) {
        lbls.forEach { $0.changeLanguage(AppUtil.shared.currentLanguage) }
    }
}


extension BaseVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var opacity: CGFloat = 0
        let startPoint = navViewHeight/2
        let headerHeight = mainHeaderHeight?.constant ?? 0
        
        if scrollView.contentOffset.y < startPoint {
            opacity = 0
        } else {
            opacity = (scrollView.contentOffset.y - startPoint) / (navViewHeight/2)
        }
        navView?.alpha = opacity
        
        if scrollView.contentOffset.y <= 0 {
            mainHeader?.setTopConstraint(0)
            opacity = 0
            strechyView?.stretch(scrollView.contentOffset.y, strechyViewHeight -  scrollView.contentOffset.y)
            
            strechyImageViewTop?.constant = scrollView.contentOffset.y
            strechyImageViewHeight?.constant = strechyViewHeight - scrollView.contentOffset.y
            
        } else {
            mainHeader?.setTopConstraint(scrollView.contentOffset.y > headerHeight ? headerHeight : scrollView.contentOffset.y)
            opacity = scrollView.contentOffset.y / 200
            strechyView?.stretch(0, strechyViewHeight)
            
            strechyImageViewTop?.constant = 0
            strechyImageViewHeight?.constant = strechyViewHeight
        }
        
//        navBar?.alpha = opacity
        if navBarEffect { navBar?.setEffect(opacity) }
        
    }
}
