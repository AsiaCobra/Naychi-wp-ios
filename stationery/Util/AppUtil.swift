//
//  AppUtil.swift
//  stationery
//
//  Created by Codigo NOL on 29/12/2020.
//

import UIKit
import DrawerMenu
import SwiftyUserDefaults
import FBSDKLoginKit
import AVFoundation

class AppUtil {
    
    static let shared = AppUtil()
    
    var currentLanguage: Language = Language.init(rawValue: Defaults[key: DefaultsKeys.language]) ?? .myanmar
    
    static func getDrawer() -> DrawerMenu? {
        return UIApplication.shared.topMostViewController as? DrawerMenu
    }
    
    static func getTabBar() -> TabbarVC? {
        guard let drawer = UIApplication.shared.topMostViewController as? DrawerMenu else { return nil }
        return drawer.centerViewController as? TabbarVC
    }
    
    static func logout() {
        
        Defaults[key: DefaultsKeys.isUserLogin] = false
        if Defaults[key: DefaultsKeys.loginType] == LoginType.facebook.rawValue {
            LoginManager().logOut()
        }
        
        let tabbar = AppUtil.getTabBar()
        tabbar?.cartPopToRoot()
        tabbar?.favPopToRoot()
        
        ShopUtil.clearCart()
        ShopUtil.clearFav()
    }
    
    static func getPriceString(price: Int) -> String {
        var priceString = price.toCurrency() ?? ""
        if AppUtil.shared.currentLanguage == .myanmar { priceString = priceString.mmNumbers() }
        return "\(priceString) \(AppUtil.shared.currentLanguage == .myanmar ? "ကျပ်" : "Ks")"
    }
    
    public static func getAppInfo() -> AppInfo? {
        guard let data: AppInfo = AppInfo.get() else {
            return nil
        }
        return data
    }
    
//    var player: AVPlayer?
    var playerLooper: AVPlayerLooper?
    var player: AVQueuePlayer?
    
    public func playMusic() {
        guard #available(iOS 14, *) else { return }
        guard let data: AppInfo = AppUtil.getAppInfo(), let music = URL(string: data.music ?? ""), player == nil else {
            player?.play()
            return
        }
        
//        let playerItem = AVPlayerItem(url: music)
//        player = AVPlayer(playerItem: playerItem)
//        if !Defaults[key: DefaultsKeys.musicPause] { player?.play() }
        
        let playerItem = AVPlayerItem(url: music)
        player = AVQueuePlayer(playerItem: playerItem)
        playerLooper = AVPlayerLooper(player: player ?? AVQueuePlayer(), templateItem: playerItem)
        if !Defaults[key: DefaultsKeys.musicPause] { player?.play() }
    }
    
    public func pauseMusic() {
        player?.pause()
    }
}
