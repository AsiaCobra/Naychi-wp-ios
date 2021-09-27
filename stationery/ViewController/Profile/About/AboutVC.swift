//  
//  AboutVC.swift
//  stationery
//
//  Created by Codigo NOL on 11/01/2021.
//

import UIKit

protocol AboutDisplayLogic: AnyObject {
    // func didSuccess(data: <DataType>)
}

class AboutVC: BaseVC, Storyboarded {
    
    static var storyboardName: String = Constant.Storyboard.profile
    
    var router: (NSObjectProtocol & AboutRoutingLogic)?

    // MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var bannerTop: NSLayoutConstraint!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblPayment: LanguageLabel!
    @IBOutlet weak var lblShipping: LanguageLabel!
    @IBOutlet weak var lblPrivacy: LanguageLabel!
    @IBOutlet weak var btnPayment: UIButton!
    @IBOutlet weak var btnShipping: UIButton!
    @IBOutlet weak var btnPrivacy: UIButton!
    
    @IBOutlet weak var lblTitle: LanguageLabel!
    @IBOutlet weak var lblDesc: LanguageLabel!
    @IBOutlet weak var lblAddress: LanguageLabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblWebsite: UILabel!
    @IBOutlet weak var lblOpeningTime: LanguageLabel!
    
    @IBOutlet weak var stackAddress: UIStackView!
    @IBOutlet weak var stackPhone: UIStackView!
    @IBOutlet weak var stackEmail: UIStackView!
    @IBOutlet weak var stackWebsite: UIStackView!
    @IBOutlet weak var stackOpeningTime: UIStackView!

    var vm: AboutVM?
    var viewAppeared = false
    
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
        let router = AboutRouter()
        let vm = AboutVM()
        viewController.router = router
        viewController.vm = vm
        router.viewController = viewController
        vm.viewController = viewController
    }

    // MARK: View Lifecycles And View Setups
    func setupView() {
        bannerHeight.constant = (UIScreen.main.bounds.width * 9) / 16 //ratio 16:9
        
        let appInfo: AppInfo? = AppUtil.getAppInfo()
        
        lblTitle.changeLanguage(AppUtil.shared.currentLanguage)
        lblDesc.setUp(textMyanmar: appInfo?.myanmar?.about ?? "", textEnglish: appInfo?.english?.about ?? "")
        lblDesc.changeLanguage(AppUtil.shared.currentLanguage)
        
        lblAddress.setUp(textMyanmar: appInfo?.myanmar?.address ?? "", textEnglish: appInfo?.english?.address ?? "",
                         fontMm: "regular", fontSizeMm: 12, fontEng: "regular", fontSizeEng: 12)
        lblAddress.changeLanguage(AppUtil.shared.currentLanguage)
        lblOpeningTime.setUp(textMyanmar: appInfo?.myanmar?.openingTime ?? "", textEnglish: appInfo?.english?.openingTime ?? "",
                         fontMm: "regular", fontSizeMm: 12, fontEng: "regular", fontSizeEng: 12)
        lblOpeningTime.changeLanguage(AppUtil.shared.currentLanguage)
        
        lblPhone.text = AppUtil.getAppInfo()?.phoneNo.joined(separator: ", ")
            //Constant.AppInfo.phoneNo.joined(separator: ", ")
        lblEmail.text = appInfo?.email
        lblWebsite.text = appInfo?.website
        
        lblPayment.changeLanguage(AppUtil.shared.currentLanguage)
        lblShipping.changeLanguage(AppUtil.shared.currentLanguage)
        lblPrivacy.changeLanguage(AppUtil.shared.currentLanguage)
        
        stackAddress.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onTappedInfo(_:))))
        stackPhone.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onTappedInfo(_:))))
        stackEmail.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onTappedInfo(_:))))
        stackWebsite.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onTappedInfo(_:))))
        stackOpeningTime.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onTappedInfo(_:))))
        
        btnPayment.addTarget(self, action: #selector(self.onTappedButton(_:)), for: .touchUpInside)
        btnShipping.addTarget(self, action: #selector(self.onTappedButton(_:)), for: .touchUpInside)
        btnPrivacy.addTarget(self, action: #selector(self.onTappedButton(_:)), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if viewAppeared { return }
        viewAppeared = true
        
        self.setStrechyView(bannerTop, bannerHeight)
        self.scrollView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @objc func onTappedInfo(_ gesture: UITapGestureRecognizer) {
        switch gesture.view {
        case stackAddress: break
        case stackPhone:
            var phones: [(id: String, value: String)] = []
            AppUtil.getAppInfo()?.phoneNo.forEach { phones.append((id: "", value: $0)) }
//            Constant.AppInfo.phoneNo.forEach { phones.append((id: "", value: $0)) }
            
            ListDialog.show("Phone Numbers", items: phones, delegate: self, tapGestureDismissal: true, panGestureDismissal: true,
                        align: .centre, shouldShowArrow: true, selectedId: "")
        case stackEmail: self.openMail()
        case stackWebsite:
            if let website = AppUtil.getAppInfo()?.website, !website.isEmpty {
                self.openURLInSafari(website)
            }
        case stackOpeningTime: break
        default: break
        }
    }
    
    @objc func onTappedButton(_ sender: UIButton) {
        guard let appInfo: AppInfo = AppUtil.getAppInfo() else { return }
        switch sender {
        case btnPayment:
            self.openURLInSafari(AppUtil.shared.currentLanguage == .myanmar ? appInfo.myanmar?.paymentLink ?? "" :
                                    appInfo.english?.paymentLink ?? "")
        case btnShipping:
            self.openURLInSafari(AppUtil.shared.currentLanguage == .myanmar ? appInfo.myanmar?.shippingLink ?? "" :
                                    appInfo.english?.shippingLink ?? "")
        case btnPrivacy:
            self.openURLInSafari(AppUtil.shared.currentLanguage == .myanmar ? appInfo.myanmar?.privacyLink ?? "" :
                                    appInfo.english?.privacyLink ?? "")
        default: break
        }
    }
}

extension AboutVC: AboutDisplayLogic {
    // func didSuccess(data: <DataType>) {}
}

extension AboutVC: ListDialogProtocol {
    func listDialog(didSelect title: String, id: String, value: String) {
        guard let url = URL(string: "tel://\(value)") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

