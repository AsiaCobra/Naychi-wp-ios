//
//  TabbarItem.swift
//  stationery
//
//  Created by Codigo NOL on 20/12/2020.
//

import UIKit

class TabbarItem: UITabBarItem {
    
    var hasBotNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0 > 20
        }
        return false
    }
    
    enum TabbarType: String {
        case home       = "Home"
        case item       = "Shop"
        case favorite   = "Wishlist"
        case cart       = "Cart"
        case profile    = "Account"
        
        func getMm() -> String {
            switch self {
            case .home: return "မူလစာမျက်နှာ"
            case .item: return "ပစ္စည်းများ"
            case .favorite: return "နှစ်သက်သော"
            case .cart: return "စျေးခြင်းတောင်း"
            case .profile: return "အကောင့်"
            }
        }
    }
    
    var tabbarType: TabbarType = .home
    
    override init() {
        super.init()
    }
    
    convenience init(type: TabbarType) {
        self.init()
        let imgNormal = getTabBarImage(by: type, isActive: false)
        let imgSelected = getTabBarImage(by: type, isActive: true)
        self.tabbarType = type
        self.title = AppUtil.shared.currentLanguage == .myanmar ? type.getMm() : type.rawValue
        self.image = imgNormal
        self.selectedImage = imgSelected
        
        if hasBotNotch {
            self.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 10)
            self.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
        }
    }
    
    func changeLanguage(_ lan: Language) {
        self.title = lan == .myanmar ?  tabbarType.getMm() : tabbarType.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func getTabBarImage(by type: TabbarType, isActive: Bool) -> UIImage? {
        switch type {
        case .home: return UIImage(named: isActive ? "iconhomered" : "iconhomeblack")?.withRenderingMode(.alwaysOriginal)
        case .item: return UIImage(named: isActive ? "iconbagred" : "iconbagblack")?.withRenderingMode(.alwaysOriginal)
        case .favorite: return UIImage(named: isActive ? "iconheartred" : "iconheartblack")?.withRenderingMode(.alwaysOriginal)
        case .cart: return UIImage(named: isActive ? "iconcartred" : "iconcartblack")?.withRenderingMode(.alwaysOriginal)
        case .profile: return UIImage(named: isActive ? "iconprofilered" : "iconprofileblack")?.withRenderingMode(.alwaysOriginal)
        }
    }
    
}
