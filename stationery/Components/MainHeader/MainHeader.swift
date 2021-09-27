//
//  MainHeader.swift
//  stationery
//
//  Created by Codigo NOL on 29/12/2020.
//

import UIKit
import DrawerMenu
import SwiftyUserDefaults

@objc protocol MainHeaderProtocol: AnyObject {
    @objc optional func mainHeader(onTappedProfile isHeader: Bool)
    @objc optional func mainHeader(onTappedHeart isHeader: Bool)
    
    func mainHeader(onTappedCart isHeader: Bool)
    func mainHeader(onSelectcategory index: Int, value: String)
}

class MainHeader: UIView {

    @IBOutlet weak var contentViewTop: NSLayoutConstraint!
    
    @IBOutlet weak var lblTitle: LanguageLabel!
    @IBOutlet weak var btnMyanmar: UIButton!
    @IBOutlet weak var btnEnglish: UIButton!
    
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnPhone: UIButton!
    @IBOutlet weak var btnMusic: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var viewContent: UIView!
    
    var onLanguageChange: ((_ lan: Language) -> Void)?
    var onMusicChange: (() -> Void)?
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupView()
    }
    
    // MAKR: Setup
    fileprivate func setupView() {
        guard let v = loadViewFromNib() else { return }
        v.frame = bounds
        v.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        initView()
        addSubview(v)
        self.backgroundColor = .clear
    }
    
    fileprivate func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.className, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        return view
    }
    
    func initView() {
        setMusicImage()
        
        btnMyanmar.addTarget(self, action: #selector(self.onTappedLanguage(_:)), for: .touchUpInside)
        btnEnglish.addTarget(self, action: #selector(self.onTappedLanguage(_:)), for: .touchUpInside)
        
        btnMenu.addTarget(self, action: #selector(self.onTappedButton(_:)), for: .touchUpInside)
        btnMusic.addTarget(self, action: #selector(self.onTappedButton(_:)), for: .touchUpInside)
        btnPhone.addTarget(self, action: #selector(self.onTappedButton(_:)), for: .touchUpInside)
        btnSearch.addTarget(self, action: #selector(self.onTappedButton(_:)), for: .touchUpInside)
    }
    
    func setMusicImage() {
        let imgMusic = UIImage(named: Defaults[key: DefaultsKeys.musicPause] ? "iconmusicoff" : "iconmusic")
        btnMusic.setImage(imgMusic, for: .normal)
        btnMusic.alpha = Defaults[key: DefaultsKeys.musicPause] ? 0.8 : 1
    }
    
    @objc func onTappedButton(_ sender: UIButton) {
        switch sender {
        case btnMenu:
            if let menu = AppUtil.getDrawer() {
                menu.open(to: .left, animated: true, completion: nil)
            }
            
        case btnMusic:
            onOffMusic()
            onMusicChange?()

        case btnPhone:
            var phones: [(id: String, value: String)] = []
            AppUtil.getAppInfo()?.phoneNo.forEach { phones.append((id: "", value: $0)) }
//            Constant.AppInfo.phoneNo.forEach { phones.append((id: "", value: $0)) }
            
            ListDialog.show("Phone Numbers", items: phones, delegate: self, tapGestureDismissal: true, panGestureDismissal: true,
                        align: .centre, shouldShowArrow: true, selectedId: "")
        case btnSearch:
            let vc = ItemSearchVC.instantiate()
            self.parentViewController?.navigationController?.pushViewController(vc, animated: true)
        default: break
        }
    }
    
    func onOffMusic() {
        Defaults[key: DefaultsKeys.musicPause] = !Defaults[key: DefaultsKeys.musicPause]
        setMusicImage()
        Defaults[key: DefaultsKeys.musicPause] ? AppUtil.shared.pauseMusic() : AppUtil.shared.playMusic()
    }
    
    func setTopConstraint(_ constant: CGFloat) {
        contentViewTop.constant = constant * -1
    }
    
    @objc func onTappedLanguage(_ sender: UIButton) {
        switch sender {
        case btnMyanmar: setLanguage(.myanmar)
        case btnEnglish: setLanguage(.english)
        default: break
        }
        
        if AppUtil.shared.currentLanguage == getLanguage() { return }
        AppUtil.shared.currentLanguage = getLanguage()
        
        lblTitle.changeLanguage(AppUtil.shared.currentLanguage)
        AppUtil.getTabBar()?.changeLanguage(AppUtil.shared.currentLanguage)
        onLanguageChange?(AppUtil.shared.currentLanguage)
    }
}

extension MainHeader: ListDialogProtocol {
    func listDialog(didSelect title: String, id: String, value: String) {
        guard let url = URL(string: "tel://\(value)") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
