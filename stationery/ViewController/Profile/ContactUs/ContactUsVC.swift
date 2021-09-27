//  
//  ContactUsVC.swift
//  stationery
//
//  Created by Codigo NOL on 16/01/2021.
//

import UIKit

protocol ContactUsDisplayLogic: AnyObject {
    func didSuccessContact()
    func didFailContact()
}

class ContactUsVC: BaseVC, Storyboarded {
    
    static var storyboardName: String = Constant.Storyboard.profile
    
    var router: (NSObjectProtocol & ContactUsRoutingLogic)?

    // MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtName: TextField!
    @IBOutlet weak var txtEmail: TextField!
    @IBOutlet weak var txtTitle: TextField!
    @IBOutlet weak var txtMessage: TextView!
    @IBOutlet weak var btnSend: UIButton!

    var vm: ContactUsVM?
    
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
        let router = ContactUsRouter()
        let vm = ContactUsVM()
        viewController.router = router
        viewController.vm = vm
        router.viewController = viewController
        vm.viewController = viewController
    }

    // MARK: View Lifecycles And View Setups
    func setupView() {
        self.navBarEffect = false
        self.navBar?.setEffect(1)
        
        if let detail = ShopUtil.getBillingDetail() {
            txtName.text = detail.name
            txtEmail.text = detail.email
        } else if let social = ShopUtil.getSocialAccountData() {
            txtName.text = social.name
            txtName.text = social.email
        }
        btnSend.addTarget(self, action: #selector(self.sendFeedback), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @objc func sendFeedback() {
        if validateForm() { sendForm() }
    }
    
    func sendForm() {
        vm?.contactUs(name: txtName.text ?? "", email: txtEmail.text ?? "",
                      title: txtTitle.text ?? "", message: txtMessage.text ?? "")
    }
    
    func validateForm() -> Bool {
        
        var isValid = true
        var inValidFields: [UIView] = []
        
        txtName.text = txtName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        txtEmail.text = txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        txtTitle.text = txtTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        txtMessage.text = txtMessage.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if txtName.text?.isEmpty ?? true {
            setErrorField(field: txtName)
            isValid = false
            inValidFields.append(txtName)
        }
        
        if let email = txtEmail.text, !email.isEmpty {
            if !email.isValidEmail() {
                setErrorField(field: txtEmail)
                isValid = false
                inValidFields.append(txtEmail)
            }
        } else {
            setErrorField(field: txtEmail)
            isValid = false
            inValidFields.append(txtEmail)
        }
        
        if txtTitle.text?.isEmpty ?? true {
            setErrorField(field: txtTitle)
            isValid = false
            inValidFields.append(txtTitle)
        }
        
        if txtMessage.text?.isEmpty ?? true {
            CustomAnimation.shake(view: txtMessage)
            txtMessage.setErrorBorder()
            isValid = false
            inValidFields.append(txtMessage)
        }
        
        if let field = inValidFields.first {
            scrollView.scrollRectToVisible(field.frame, animated: true)
        }
        
        return isValid
    }
    
    func setErrorField(field: TextField) {
        CustomAnimation.shake(view: field)
        field.setErrorBorder()
    }
}

extension ContactUsVC: ContactUsDisplayLogic {
    
    func didSuccessContact() {
        NotiBanner.toast(AppUtil.shared.currentLanguage == .myanmar ? "ဆက်သွယ်သည့်အတွက် ကျေးဇူးတင်ပါသည်။" : "Thank you for contacting us.", icon: nil, type: .success)
        self.navigationController?.popViewController(animated: true)
    }
    
    func didFailContact() {
        Dialog.showApiError(tryAgain: { [weak self] in
            self?.sendForm()
        }, cancelAble: true)
    }
}
