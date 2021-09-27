//  
//  EditProfileVC.swift
//  stationery
//
//  Created by Codigo NOL on 13/01/2021.
//

import UIKit

protocol EditProfileDisplayLogic: AnyObject {
    func didSuccessUpdate()
    func didFailUpdate()
}

class EditProfileVC: BaseVC, Storyboarded {
    
    static var storyboardName: String = Constant.Storyboard.profile
    
    var router: (NSObjectProtocol & EditProfileRoutingLogic)?

    // MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtName: TextFieldWithTitle!
    @IBOutlet weak var txtCountry: TextFieldWithTitle!
    @IBOutlet weak var pickerState: PickerViewWithTitle!
    @IBOutlet weak var pickerTownship: PickerViewWithTitle!
    @IBOutlet weak var txtStreet: TextFieldWithTitle!
    @IBOutlet weak var txtMobile: TextFieldWithTitle!
    @IBOutlet weak var txtEmail: TextFieldWithTitle!
    @IBOutlet weak var btnSave: LanguageButton!

    var vm: EditProfileVM?
    
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
        let router = EditProfileRouter()
        let vm = EditProfileVM()
        viewController.router = router
        viewController.vm = vm
        router.viewController = viewController
        vm.viewController = viewController
    }

    // MARK: View Lifecycles And View Setups
    func setupView() {
        self.navBarEffect = false
        navBar?.setEffect(1)
        
        txtName.setTitleLanguage("အမည်", "Name")
        txtCountry.setTitleLanguage("နိုင်ငံ", "Country / Region")
        pickerState.setTitleLanguage("တိုင်း / ပြည်နယ်", "State / Division")
        pickerTownship.setTitleLanguage("မြို့၊ မြို့နယ်", "Township")
        txtStreet.setTitleLanguage("လမ်းလိပ်စာ", "Street Address")
        txtMobile.setTitleLanguage("ဖုန်းနံပါတ်", "Billing Mobile Number")
        txtEmail.setTitleLanguage("အီမေးလ် (optional)", "Billing Email (optional)")
        btnSave.changeLanguage(AppUtil.shared.currentLanguage)
        
        txtCountry.text = AppUtil.shared.currentLanguage == .myanmar ? "မြန်မာ": "Myanmar"
        
        txtCountry.viewBackgroundColor = Color.Gray.instance()
        txtCountry.isUserInteractionEnabled = false
        
        btnSave.addTarget(self, action: #selector(self.onTappedSave), for: .touchUpInside)
        pickerState.delegate = self
        pickerTownship.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setUpData()
    }
    
    func setUpData() {
        
        let states = ShopUtil.getStates()
        pickerState.setData(items: states)
        
        if let detail = ShopUtil.getBillingDetail()  {
            let state = AppUtil.shared.currentLanguage == .myanmar ? detail.stateMm : detail.state
            pickerState.setValue(state)
            
            pickerTownship.setData(items: ShopUtil.getTownships(state))
            pickerTownship.setValue(AppUtil.shared.currentLanguage == .myanmar ? detail.townshipMm :detail.township)
            
            txtName.text = detail.name
            txtCountry.text = detail.country
            txtStreet.text = detail.streetAddress
            txtMobile.text = detail.mobile
            txtEmail.text = detail.email
            return
        }
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
        
        return isValid
    }
    
    @objc func onTappedSave() {
        if formValidate() {
            updateCustomer()
        }
    }
    
    func updateCustomer() {
        guard let detail = ShopUtil.getBillingDetail(), let customerId = detail.customerId else { return }
        var state = pickerState.getSelectedValue() ?? ""
        var township = pickerTownship.getSelectedValue() ?? ""
        
        if AppUtil.shared.currentLanguage == .myanmar {
            state = Region.getStateEng(state)
            township = Region.getTownshipEng(state, township)
        }
        
        vm?.update(id: customerId, name: txtName.text ?? "", country: txtCountry.text ?? "",
                   state: state, township: township,
                   address: txtStreet.text ?? "", mobile: txtMobile.text ?? "", email: txtEmail.text ?? "")
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

extension EditProfileVC: EditProfileDisplayLogic {
    func didSuccessUpdate() {
        saveDetail() 
        NotiBanner.toast(AppUtil.shared.currentLanguage == .myanmar ? "အချက်အလက််များ သိမ်းလိုက်ပါပြီ။" : "Profile Saved", icon: nil, type: .success)
        self.navigationController?.popViewController(animated: true)
    }
    
    func didFailUpdate() {
        Dialog.showApiError(tryAgain: {
            self.updateCustomer()
        }, cancelAble: true)
    }
}


extension EditProfileVC: TextFieldWithTitleDelegate, PickerViewWithTitleProtocol {
    
    func pickerViewWithTitle(onSelected selectedString: String, picker: PickerViewWithTitle) {}
    
    func pickerViewWithTitle(editingDone selectedString: String?, picker: PickerViewWithTitle) {
        if picker == pickerState {
            pickerTownship.reset()
            pickerTownship.setData(items: ShopUtil.getTownships(selectedString ?? ""))
        }
    }    
}
