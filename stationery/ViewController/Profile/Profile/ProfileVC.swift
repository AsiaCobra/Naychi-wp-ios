//  
//  ProfileVC.swift
//  stationery
//
//  Created by Codigo NOL on 20/12/2020.
//

import UIKit
import SwiftyUserDefaults
import FBSDKLoginKit
import AuthenticationServices

protocol ProfileDisplayLogic: AnyObject {
    func didSuccessCreateCustomer()
    func didFailCreateCustomer()
}

class ProfileVC: BaseVC, Storyboarded {
    
    static var storyboardName: String = Constant.Storyboard.profile
    
    var router: (NSObjectProtocol & ProfileRoutingLogic)?
    
    // MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    //Account
    @IBOutlet weak var accountView: UIStackView!
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var lblPhoto: UILabel!
    
    @IBOutlet weak var lblMobileTitle: LanguageLabel!
    @IBOutlet weak var lblEmailTitle: LanguageLabel!
    @IBOutlet weak var lblStateTitle: LanguageLabel!
    @IBOutlet weak var lblTownshipTitle: LanguageLabel!
    @IBOutlet weak var lblAddressTitle: LanguageLabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMobile: LanguageLabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblState: LanguageLabel!
    @IBOutlet weak var lblTownship: LanguageLabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnOrder: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var btnAccount: UIButton!
    
    @IBOutlet weak var lblOrders: LanguageLabel!
    @IBOutlet weak var lblLogout: LanguageLabel!
    
    //Login
    @IBOutlet weak var lblLoginTitle: LanguageLabel!
    @IBOutlet weak var lblLoginDesc: LanguageLabel!
    @IBOutlet weak var loginView: UIStackView!
    @IBOutlet weak var lblFacebook: LanguageLabel!
    @IBOutlet weak var imgFacebook: UIImageView!
    @IBOutlet weak var lblApple: LanguageLabel!
    @IBOutlet weak var imgApples: UIImageView!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnApple: UIButton!
    
    //Other
    @IBOutlet weak var lblContactUs: LanguageLabel!
    @IBOutlet weak var lblAboutUs: LanguageLabel!
    @IBOutlet weak var lblOurFbPage: LanguageLabel!
    @IBOutlet weak var btnContactUs: UIButton!
    @IBOutlet weak var btnAboutUs: UIButton!
    @IBOutlet weak var btnOurFbPage: UIButton!
    
    var vm: ProfileVM?
    var socialAccountData = SocialAccountData()
    var logintType = LoginType.facebook
    
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
        let router = ProfileRouter()
        let vm = ProfileVM()
        viewController.router = router
        viewController.vm = vm
        router.viewController = viewController
        vm.viewController = viewController
    }
    
    // MARK: View Lifecycles And View Setups
    func setupView() {
        showHideViews()
        scrollView.delegate = self
        
        changeLanguage()
        
        btnFacebook.addTarget(self, action: #selector(self.onTappedLogin(_:)), for: .touchUpInside)
        if #available(iOS 13.0, *) {
            btnApple.addTarget(self, action: #selector(self.onTappedLogin(_:)), for: .touchUpInside)
        } else {
            btnApple.superview?.isHidden = true
        }
        
        btnAccount.addTarget(self, action: #selector(self.onTappedButton(_:)), for: .touchUpInside)
        btnOrder.addTarget(self, action: #selector(self.onTappedButton(_:)), for: .touchUpInside)
        btnLogout.addTarget(self, action: #selector(self.onTappedButton(_:)), for: .touchUpInside)
        
        btnAboutUs.addTarget(self, action: #selector(self.onTappedButton(_:)), for: .touchUpInside)
        btnContactUs.addTarget(self, action: #selector(self.onTappedButton(_:)), for: .touchUpInside)
        btnOurFbPage.addTarget(self, action: #selector(self.onTappedButton(_:)), for: .touchUpInside)
        
        self.mainHeader?.onLanguageChange = { _ in
            self.changeLanguage()
        }
    }
    
    func showHideViews() {
        accountView.isHidden = !Defaults[key: DefaultsKeys.isUserLogin]
        loginView.isHidden = Defaults[key: DefaultsKeys.isUserLogin]
    }
    
    func changeLanguage() {
        
        lblMobileTitle.changeLanguage(AppUtil.shared.currentLanguage)
        lblEmailTitle.changeLanguage(AppUtil.shared.currentLanguage)
        lblStateTitle.changeLanguage(AppUtil.shared.currentLanguage)
        lblTownshipTitle.changeLanguage(AppUtil.shared.currentLanguage)
        lblAddressTitle.changeLanguage(AppUtil.shared.currentLanguage)
        lblOrders.changeLanguage(AppUtil.shared.currentLanguage)
        lblLogout.changeLanguage(AppUtil.shared.currentLanguage)
        
        lblState.changeLanguage(AppUtil.shared.currentLanguage)
        lblTownship.changeLanguage(AppUtil.shared.currentLanguage)
        
        lblLoginTitle.changeLanguage(AppUtil.shared.currentLanguage)
        lblLoginDesc.changeLanguage(AppUtil.shared.currentLanguage)
        lblFacebook.changeLanguage(AppUtil.shared.currentLanguage)
        lblApple.changeLanguage(AppUtil.shared.currentLanguage)
        lblContactUs.changeLanguage(AppUtil.shared.currentLanguage)
        lblAboutUs.changeLanguage(AppUtil.shared.currentLanguage)
        lblOurFbPage.changeLanguage(AppUtil.shared.currentLanguage)
    }
    
    func setUpData() {
        if !Defaults[key: DefaultsKeys.isUserLogin] { return }
        
        vm?.setProfileImage(imgPhoto, lblPhoto)
        let detail = ShopUtil.getBillingDetail()
        
        let defaultValue = "----------"
        lblName.text = (detail?.name ?? "").isEmpty ? defaultValue : detail?.name
        lblMobile.text = (detail?.mobile ?? "").isEmpty ? defaultValue : detail?.mobile
        lblEmail.text = (detail?.email ?? "").isEmpty ?  defaultValue : detail?.email
        
        let state = detail?.state ?? ""
        let stateMm = detail?.stateMm ?? ""
        let township = detail?.township ?? ""
        let townshipMm = detail?.townshipMm ?? ""
        
        lblState.textEnglish = state.isEmpty ? defaultValue : state
        lblState.textMyanmar = stateMm.isEmpty ? defaultValue : stateMm
        lblState.changeLanguage(AppUtil.shared.currentLanguage)
        
        lblTownship.textEnglish = township.isEmpty ? defaultValue : township
        lblTownship.textMyanmar = townshipMm.isEmpty ? defaultValue : townshipMm
        lblTownship.changeLanguage(AppUtil.shared.currentLanguage)
        
        lblAddress.text = (detail?.streetAddress ?? "").isEmpty ?  defaultValue : detail?.streetAddress
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpData()
        showHideViews()
    }
    
    @objc func onTappedLogin(_ sender: UIButton) {
        switch sender {
        case btnFacebook: loginWithFacebook()
        case btnApple: if #available(iOS 13.0, *) { loginWithApple() }
        default: break
        }
    }
    
    @objc func onTappedButton(_ sender: UIButton) {
        switch sender {
        case btnAccount: router?.routeToEditProfile()
        case btnOrder: router?.routeToOrders()
        case btnLogout:
            AppUtil.logout()
            showHideViews()
        case btnAboutUs: router?.routeToAboutUs()
        case btnContactUs: router?.routeToContactUs()
        case btnOurFbPage:
            if let fbPage = AppUtil.getAppInfo()?.fbPage, !fbPage.isEmpty {
                self.openURLInSafari(fbPage)
            }
            
        default: break
        }
    }
    
    func loginWithFacebook () {
//        LoadingView.shared.show()
        vm?.loginWithFacebook(vc: self, completion: { [weak self] data, error in
//            LoadingView.shared.hide()
            if let e = error, !e.isEmpty {
                Dialog.show("Error", message: e, parentVC: self)
                return
            }
            
            guard let d = data else {
                Dialog.show("Error", message: "Something went wrong. Please try again.", parentVC: self)
                return
            }
            self?.socialAccountData = d
            self?.logintType = .facebook
            self?.vm?.createCustomer(data: d, loginType: self?.logintType ?? .facebook)
        })
    }
    
    @available(iOS 13.0, *)
    @objc func loginWithApple() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.requestedOperation = .operationRefresh

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
//        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension ProfileVC: ProfileDisplayLogic {
    func didSuccessCreateCustomer() {        
        showHideViews()
        setUpData()
    }
    
    func didFailCreateCustomer() {
        Dialog.showApiError(tryAgain: {
            self.vm?.createCustomer(data: self.socialAccountData, loginType: self.logintType)
        }, cancelAble: true)
    }
}

extension ProfileVC: ASAuthorizationControllerDelegate { // }, ASAuthorizationControllerPresentationContextProviding {
    
//    @available(iOS 13.0, *)
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        return self.view.window ?? UIApplication.shared.keyWindow!
//    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return
        }
        let userId = appleIDCredential.user
        let fullName = appleIDCredential.fullName
        
        guard let email = appleIDCredential.email, !email.isEmpty else {
            Dialog.show(Constant.ApiMessage.errorTitle, message: Constant.ApiMessage.errorMessageAppleEmail)
            return
        }
            
        let firstName = fullName?.givenName
        let lastName = fullName?.familyName
        
        socialAccountData = SocialAccountData()
        socialAccountData.setData(id: userId, name: "\(firstName ?? "") \(lastName ?? "")", firstName: firstName ?? "",
                                  lastName: lastName ?? "", email: email)
        logintType = .apple
        vm?.createCustomer(data: socialAccountData, loginType: logintType)
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
        Dialog.show(Constant.ApiMessage.errorTitle, message: Constant.ApiMessage.errorMessageAppleID)
    }
}
