//  
//  MenuVC.swift
//  stationery
//
//  Created by Codigo NOL on 20/12/2020.
//

import UIKit
import SwiftyUserDefaults

protocol MenuDisplayLogic: AnyObject {
    // func didSuccess(data: <DataType>)
}

class MenuVC: BaseVC, Storyboarded {
    
    static var storyboardName: String = Constant.Storyboard.main
    
    var router: (NSObjectProtocol & MenuRoutingLogic)?

    // MARK: Outlets
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var lblLogin: LanguageLabel!
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var lblHome: LanguageLabel!
    @IBOutlet weak var btnHome: UIButton!
    
    @IBOutlet weak var lblBrand: LanguageLabel!
    @IBOutlet weak var btnBrand: UIButton!
    
    @IBOutlet weak var lblCategory: LanguageLabel!
    @IBOutlet weak var btnCategory: UIButton!
    
    @IBOutlet weak var lblContact: LanguageLabel!
    @IBOutlet weak var btnContactUs: UIButton!
    
    @IBOutlet weak var lblAboutUs: LanguageLabel!
    @IBOutlet weak var btnAboutUs: UIButton!
    
    @IBOutlet weak var lblFacebook: LanguageLabel!
    @IBOutlet weak var btnFacebook: UIButton!
    
    var vm: MenuVM?
    var menuItems: [MenuItem] = []
    
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
        let router = MenuRouter()
        let vm = MenuVM()
        viewController.router = router
        viewController.vm = vm
        router.viewController = viewController
        vm.viewController = viewController
    }

    // MARK: View Lifecycles And View Setups
    func setupView() {
        Constant.AppInfo.menu.forEach { menu in
            let item = MenuItem()
            item.data = menu
            item.delegate = self
            stackView.addArrangedSubview(item)
            item.heightAnchor.constraint(equalToConstant: 50).isActive = true
            menuItems.append(item)
        }
        
        btnLogin.addTarget(self, action: #selector(self.onTappedButton(_:)), for: .touchUpInside)
        btnHome.addTarget(self, action: #selector(self.onTappedButton(_:)), for: .touchUpInside)
        btnBrand.addTarget(self, action: #selector(self.onTappedButton(_:)), for: .touchUpInside)
        btnCategory.addTarget(self, action: #selector(self.onTappedButton(_:)), for: .touchUpInside)
        btnContactUs.addTarget(self, action: #selector(self.onTappedButton(_:)), for: .touchUpInside)
        btnAboutUs.addTarget(self, action: #selector(self.onTappedButton(_:)), for: .touchUpInside)
        btnFacebook.addTarget(self, action: #selector(self.onTappedButton(_:)), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userName = ShopUtil.getBillingDetail()?.name ?? "Login/Signup"
        if Defaults[key: DefaultsKeys.isUserLogin] {
            lblLogin.changeLanguage(.myanmar, title: userName)
        } else {
            lblLogin.changeLanguage(AppUtil.shared.currentLanguage)
        }
        
        self.languageCheck(lbls: [lblHome, lblBrand, lblCategory, lblContact, lblAboutUs, lblFacebook])
        
        menuItems.forEach{ $0.lblTitle.changeLanguage(AppUtil.shared.currentLanguage) }
    }
    
    @objc func onTappedButton(_ sender: UIButton) {
        switch sender {
        case btnLogin:
            AppUtil.getDrawer()?.close(to: .left)
            AppUtil.getTabBar()?.routeTo(screen: .profile)
        case btnHome:
            AppUtil.getDrawer()?.close(to: .left)
            AppUtil.getTabBar()?.routeTo(screen: .home)
        case btnBrand:
            AppUtil.getDrawer()?.close(to: .left)
            AppUtil.getTabBar()?.getCurrentNav()?.pushViewController(BrandVC.instantiate(), animated: true)
        case btnCategory:
            AppUtil.getDrawer()?.close(to: .left)
            AppUtil.getTabBar()?.routeTo(screen: .home)
            AppUtil.getTabBar()?.getCurrentNav()?.pushViewController(CategoryVC.instantiate(), animated: true)
        case btnContactUs:
            AppUtil.getDrawer()?.close(to: .left)
            AppUtil.getTabBar()?.getCurrentNav()?.pushViewController(ContactUsVC.instantiate(), animated: true)
        case btnAboutUs:
            AppUtil.getDrawer()?.close(to: .left)
            AppUtil.getTabBar()?.getCurrentNav()?.pushViewController(AboutVC.instantiate(), animated: true)
        case btnFacebook:
            guard let fbPage = AppUtil.getAppInfo()?.fbPage, !fbPage.isEmpty else { return }
            self.openURLInSafari(fbPage)
        default: break
        }
    }
}

extension MenuVC: MenuDisplayLogic {
    // func didSuccess(data: <DataType>) {}
}

extension MenuVC: MenuItemProtocol {
    func menuItem(onTapped link: String) {
        self.openURLInSafari(link)
    }
}
