//  
//  CartDetailVC.swift
//  stationery
//
//  Created by Codigo NOL on 02/01/2021.
//

import UIKit

protocol CartDetailDisplayLogic: AnyObject {
    // func didSuccess(data: <DataType>)
}

class CartDetailVC: BaseVC, Storyboarded {
    
    static var storyboardName: String = Constant.Storyboard.cart
    
    var router: (NSObjectProtocol & CartDetailRoutingLogic)?

    // MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblTitle: LanguageLabel!
    @IBOutlet weak var txtName: TextFieldWithTitle!
    @IBOutlet weak var txtCountry: TextFieldWithTitle!
    @IBOutlet weak var pickerState: PickerViewWithTitle!
    @IBOutlet weak var pickerTownship: PickerViewWithTitle!
    @IBOutlet weak var txtStreet: TextFieldWithTitle!
    @IBOutlet weak var txtMobile: TextFieldWithTitle!
    @IBOutlet weak var txtEmail: TextFieldWithTitle!
    @IBOutlet weak var btnNext: LanguageButton!
    
    @IBOutlet weak var lblPrivacy: LabelHyperLink!
    @IBOutlet weak var imgCheckTerms: UIImageView!
    @IBOutlet weak var lblTerms: LanguageLabel!
    @IBOutlet weak var btnTerms: UIButton!

    var vm: CartDetailVM?
    var agreeToTerms = false
    
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
        let router = CartDetailRouter()
        let vm = CartDetailVM()
        viewController.router = router
        viewController.vm = vm
        router.viewController = viewController
        vm.viewController = viewController
    }

    // MARK: View Lifecycles And View Setups
    func setupView() {
        self.hero.isEnabled = true
        
        lblTitle.changeLanguage(AppUtil.shared.currentLanguage)
        txtName.setTitleLanguage("အမည်", "Name")
        txtCountry.setTitleLanguage("နိုင်ငံ", "Country / Region")
        pickerState.setTitleLanguage("တိုင်း / ပြည်နယ်", "State / Division")
        pickerTownship.setTitleLanguage("မြို့၊ မြို့နယ်", "Township")
        txtStreet.setTitleLanguage("လမ်းလိပ်စာ", "Street Address")
        txtMobile.setTitleLanguage("ဖုန်းနံပါတ်", "Billing Mobile Number")
        txtEmail.setTitleLanguage("အီမေးလ် (optional)", "Billing Email (optional)")
        btnNext.changeLanguage(AppUtil.shared.currentLanguage)
        
        txtCountry.text = AppUtil.shared.currentLanguage == .myanmar ? "မြန်မာ": "Myanmar"
        txtCountry.viewBackgroundColor = Color.Gray.instance()
        txtCountry.isUserInteractionEnabled = false
        
        let lan = AppUtil.shared.currentLanguage
        
        lblPrivacy.setHyperLink(fullText: lan == .myanmar ? Constant.Message.privacyMm : Constant.Message.privacy,
                                hyperLinkText: [Constant.Message.privacyHyper], urlString: ["privacy"],
                                textColor: Color.Black.instance(), hyperLinkColor: Color.Red.instance(),
                                textFont: lan == .myanmar ? Font.MMBold.of(size: 14) : Font.Bold.of(size: 14),
                                linkFont: lan == .myanmar ? Font.MMBold.of(size: 14) : Font.Bold.of(size: 14),
                                underLineForLink: false, textAlign: .left, lineSpacing: 0, delegate: self)
        agreeTerms(agreeToTerms)
        lblTerms.changeLanguage(lan)
        
        btnTerms.addTarget(self, action: #selector(self.onTappedTerms), for: .touchUpInside)
        btnNext.addTarget(self, action: #selector(self.onTappedNext), for: .touchUpInside)
        
        txtName.delegate = self
        txtCountry.delegate = self
        pickerState.delegate = self
        pickerTownship.delegate = self
        txtStreet.delegate = self
        txtMobile.delegate = self
        txtEmail.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setUpData()
    }
    
    func setUpData() {
        let lan = AppUtil.shared.currentLanguage
        let states = ShopUtil.getStates()
        pickerState.setData(items: states)
        
        if let detail = ShopUtil.getBillingDetail()  {
            let currentState = lan == .myanmar ? detail.stateMm : detail.state
            let currentTown = lan == .myanmar ? detail.townshipMm : detail.township
            pickerState.setValue(currentState)
            
            pickerTownship.setData(items: ShopUtil.getTownships(currentState))
            pickerTownship.setValue(currentTown)
            
            txtName.text = detail.name
            txtCountry.text = AppUtil.shared.currentLanguage == .myanmar ? detail.countryMm : detail.country
            txtStreet.text = detail.streetAddress
            txtMobile.text = detail.mobile
            txtEmail.text = detail.email
            return
        }
        
//        guard let cartTotal: CartTotal = CartTotal.get() else { return }
//
//        pickerState.setValue(cartTotal.state ?? "Yangon")
//
//        pickerTownship.setData(items: ShopUtil.getTownships(cartTotal.state ?? "Yangon"))
//        pickerTownship.setValue(cartTotal.township ?? "")
//
//        saveDetail()
    }
    
    func formValidate() -> Bool {
        var isValid = true
        
        let textFields: [TextFieldWithTitle] = [txtName, txtStreet, txtMobile]
        var inValidFields: [TextFieldWithTitle] = []
        
        textFields.forEach {
            if $0.text?.isEmpty ?? true {
                CustomAnimation.shake(view: $0)
                $0.setError()
                isValid = false
                inValidFields.append($0)
            }
        }
        
        if let field = inValidFields.first {
            scrollView.scrollRectToVisible(field.frame, animated: true)
        }
        
        if pickerTownship.getSelectedValue() == nil {
            CustomAnimation.shake(view: pickerTownship)
            pickerTownship.setError()
            isValid = false
        }
        
        if let email = txtEmail.text, !email.isEmpty {
            if !email.isValidEmail() {
                txtEmail.setError()
                CustomAnimation.shake(view: txtEmail)
                isValid = false
                inValidFields.append(txtEmail)
            }
        }
        
        if !agreeToTerms {
            lblTerms.textColor = Color.Red.instance()
            CustomAnimation.shake(view: lblTerms)
            isValid = false
        }
        
        return isValid
    }
    
    func agreeTerms(_ agree: Bool) {
        lblTerms.textColor = Color.Black.instance()
        agreeToTerms = agree
        imgCheckTerms.image = UIImage(named: agree ? "iconcheckfill" : "iconcheckempty")
    }
    
    @objc func onTappedTerms() {
        agreeTerms(!agreeToTerms)
    }
    
    @objc func onTappedNext() {
        if formValidate() {
            router?.routeToOrder()
        }
    }
    
    func saveDetail() {
        ShopUtil.saveBillingDetail(name: txtName.text ?? "", country: txtCountry.text ?? "",
                                   state: pickerState.getSelectedValue() ?? "",
                                   township: pickerTownship.getSelectedValue() ?? "", address: txtStreet.text ?? "",
                                   mobile: txtMobile.text ?? "", email: txtEmail.text ?? "")
        
        guard let data: CartTotal = CartTotal.get() else { return }
        data.saveValue {
            data.state = vm?.getStateInEng(pickerState)
            data.township = vm?.getTownshipInEng(pickerState, pickerTownship)
            data.deliveryFees = Region.getFees(vm?.getStateInEng(pickerState) ?? "", vm?.getTownshipInEng(pickerState, pickerTownship) ?? "")
            data.isInYangon = vm?.getStateInEng(pickerState) == "Yangon"
        }
    }
}

extension CartDetailVC: CartDetailDisplayLogic {
    // func didSuccess(data: <DataType>) {}
}

extension CartDetailVC: LabelHyperLinkProtocol {
    func labelHyperLink(onTappedUrlInLabel urlString: String) {
        guard let appInfo: AppInfo = AppUtil.getAppInfo() else { return }
        self.openURLInSafari(AppUtil.shared.currentLanguage == .myanmar ? appInfo.myanmar?.privacyLink ?? "" : appInfo.english?.privacyLink ?? "")
    }
}

extension CartDetailVC: TextFieldWithTitleDelegate, PickerViewWithTitleProtocol {
    
    func pickerViewWithTitle(onSelected selectedString: String, picker: PickerViewWithTitle) {}
    
    func pickerViewWithTitle(editingDone selectedString: String?, picker: PickerViewWithTitle) {
        if picker == pickerState {
            pickerTownship.reset()
            pickerTownship.setData(items: ShopUtil.getTownships(selectedString ?? ""))
        }
        saveDetail()
    }
    
    func textFieldWithTitle(didEndEditing textField: TextFieldWithTitle) {
        saveDetail()
    }
    
}
