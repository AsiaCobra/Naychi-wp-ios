//  
//  TabbarVC.swift
//  stationery
//
//  Created by Codigo NOL on 20/12/2020.
//

import UIKit

protocol TabbarDisplayLogic: AnyObject {
    // func didSuccess(data: <DataType>)
}

class TabbarVC: UITabBarController, Storyboarded {
    
    static var storyboardName: String = Constant.Storyboard.main
    
    var router: (NSObjectProtocol & TabbarRoutingLogic)?

    var botNotch: CGFloat {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        }
        return 0
    }
    
    
    // MARK: Outlets
    // @IBOutlet weak var someView: UIView!

    var vm: TabbarVM?
    var viewAppeared = false
    var normalAttribute: [NSAttributedString.Key: Any]?
    var selectedAttribute: [NSAttributedString.Key: Any]?
    
    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    private func setup() {
        let viewController = self
        let router = TabbarRouter()
        let vm = TabbarVM()
        viewController.router = router
        viewController.vm = vm
        router.viewController = viewController
        vm.viewController = viewController
    }

    // MARK: View Lifecycles And View Setups
    func setupView() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Color.Red.instance()], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        
        let itemHome    = TabbarItem(type: .home)
        let itemShop    = TabbarItem(type: .item)
        let itemCart    = TabbarItem(type: .cart)
        let itemFav     = TabbarItem(type: .favorite)
        let itemProfile = TabbarItem(type: .profile)
        
        let navHome    = HomeVC.instantiateWithNavi()
        let navShop    = ItemVC.instantiateWithNavi()
        let navCart   = CartVC.instantiateWithNavi()
        let navFav     = FavoriteVC.instantiateWithNavi()
        let navProfile = ProfileVC.instantiateWithNavi()

        navHome.tabBarItem    = itemHome
        navShop.tabBarItem    = itemShop
        navCart.tabBarItem    = itemCart
        navFav.tabBarItem     = itemFav
        navProfile.tabBarItem = itemProfile

        delegate = self
        tabBar.barTintColor = .white
        viewControllers = [navHome, navShop, navCart, navFav, navProfile]
        
        routeTo(screen: .home)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewAppeared { return }
        viewAppeared = true
        
        if let noti = Constant.AppInfo.homeNoti, noti.status?.lowercased() == "on" {
            Dialog.show("", message: AppUtil.shared.currentLanguage == .english ? noti.textEng ?? "" : noti.textMm ?? "")
        }
    }
    
    func routeTo(screen: TabbarItem.TabbarType) {
        switch screen {
        case .home: self.selectedIndex = 0
        case .item: self.selectedIndex = 1
        case .cart: self.selectedIndex = 2
        case .favorite: self.selectedIndex = 3
        case .profile: self.selectedIndex = 4
        }
    }
    
    func cartPopToRoot() {
        guard let nav = self.viewControllers?[2] as? UINavigationController else { return }
        nav.popToRootViewController(animated: true)
    }
    
    func favPopToRoot() {
        guard let nav = self.viewControllers?[3] as? UINavigationController else { return }
        nav.popToRootViewController(animated: true)
    }
    
    func getCurrentNav() -> UINavigationController? {
        return self.viewControllers?[self.selectedIndex] as? UINavigationController
    }
    
    func getHomeScreen() -> HomeVC? {
        guard let nav = self.viewControllers?.first as? UINavigationController else { return nil }
        return nav.viewControllers.first as? HomeVC
    }
    
    func changeLanguage(_ lan: Language) {
        self.viewControllers?.forEach({ (vc) in
            if let item = vc.tabBarItem as? TabbarItem {
                item.changeLanguage(lan)
            }
        })
    }
}

extension TabbarVC: TabbarDisplayLogic {
    // func didSuccess(data: <DataType>) {}
}


extension TabbarVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            return false
        }
        
        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.2, options: [.transitionCrossDissolve], completion: nil)
        }
        
        return true
    }
}
