//  
//  OrderHistoryDetailVC.swift
//  stationery
//
//  Created by Codigo NOL on 26/06/2021.
//

import UIKit

protocol OrderHistoryDetailDisplayLogic: AnyObject {
    // func didSuccess(data: <DataType>)
}

class OrderHistoryDetailVC: BaseVC, Storyboarded {
    
    static var storyboardName: String = Constant.Storyboard.profile
    
    var router: (NSObjectProtocol & OrderHistoryDetailRoutingLogic)?

    // MARK: Outlets
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var lblOrderNo: LanguageLabel!
    @IBOutlet weak var lblDate: LanguageLabel!
    @IBOutlet weak var lblTotalTop: LanguageLabel!
    @IBOutlet weak var lblPaymentMethod: LanguageLabel!
    @IBOutlet weak var lblStatus: LanguageLabel!
    
    @IBOutlet weak var stackProduct: UIStackView!
    @IBOutlet weak var lblSubTotal: LanguageLabel!
    
    @IBOutlet weak var discountView: UIView!
    @IBOutlet weak var discountDivider: UIView!
    @IBOutlet weak var lblDiscount: LanguageLabel!
    @IBOutlet weak var lblDeliveryFees: LanguageLabel!
    
    @IBOutlet weak var lblPayment: LanguageLabel!
    @IBOutlet weak var lblTotal: LanguageLabel!
    
    @IBOutlet weak var btnSaveSlip: UIButton!
    @IBOutlet weak var btnPhone: UIButton!

    var vm: OrderHistoryDetailVM?
    var data: OrderHistory?
    
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
        let router = OrderHistoryDetailRouter()
        let vm = OrderHistoryDetailVM()
        viewController.router = router
        viewController.vm = vm
        router.viewController = viewController
        vm.viewController = viewController
    }

    // MARK: View Lifecycles And View Setups
    func setupView() {
        self.navBarEffect = false
        self.navBar?.setEffect(1)
        
        self.navBar?.title = "Order: \(data?.number ?? "")"
        btnSaveSlip.addTarget(self, action: #selector(self.saveSlip), for: .touchUpInside)
        btnPhone.addTarget(self, action: #selector(self.onTappedPhone), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setUpData()
    }
    
    func setUpData() {
        let lan = AppUtil.shared.currentLanguage
        
        lblOrderNo.changeLanguage(lan, title: lan == .myanmar ? data?.number?.mmNumbers() : data?.number)
        let date = data?.dateCreated?.toDate(dateFormat: "yyyy-MM-dd'T'HH:mm:ss", setLocalTimeZone: true) ?? Date()
        let month = date.toString("MMMM", setLocalTimeZone: true)
        let dateNo = date.toString("d, yyyy", setLocalTimeZone: true)
        let dateString = lan == .myanmar ? "\(month.mmMonth()) \(dateNo.mmNumbers())" : "\(month) \(dateNo)"
        lblDate.changeLanguage(lan, title: dateString)
        
        let methodMm = PaymentType.getTypeMm(data?.paymentMethodTitle?.lowercased() ?? "")
        lblPayment.changeLanguage(lan, title: lan == .myanmar ? methodMm.title : data?.paymentMethodTitle)
        lblPaymentMethod.changeLanguage(lan, title: lan == .myanmar ? methodMm.title : data?.paymentMethodTitle)
        
        lblStatus.text = data?.status?.capitalized
        switch OrderStatus(rawValue: data?.status ?? "") {
        case .pending, .processing, .onHold: lblStatus.textColor = Color.JungleGreen.instance()
        case .completed: lblStatus.textColor = Color.Blue.instance()
        case .cancelled, .refunded, .failed: lblStatus.textColor = Color.Red.instance()
        case .none: lblStatus.textColor = Color.Black.instance()
        }
        
        let products = data?.lineItems ?? []
        
        products.forEach { item in
            let titile = "\(item.name ?? "") x \(item.quantity ?? 0)"
            let price = item.price ?? 0//ShopUtil.getPrice(item.priceNormal, quantity: item.quantity, withDiscount: false)
            
            let product = ProductView()
            product.setData(title: titile, price: AppUtil.getPriceString(price: price))
            stackProduct.addArrangedSubview(product)
        }
        
        lblSubTotal.changeLanguage(lan, title: AppUtil.getPriceString(price: data?.total?.toInt ?? 0))
        
        discountView.isHidden = data?.discountTotal?.toInt ?? 0 <= 0
        discountDivider.isHidden = discountView.isHidden
        lblDiscount.changeLanguage(lan, title: AppUtil.getPriceString(price: data?.discountTotal?.toInt ?? 0))
        lblDeliveryFees.changeLanguage(lan, title: AppUtil.getPriceString(price: data?.shippingTotal?.toInt ?? 0))
        
        let total = data?.total?.toInt ?? 0
        lblTotal.changeLanguage(lan, title: AppUtil.getPriceString(price: total))
        lblTotalTop.changeLanguage(lan, title: AppUtil.getPriceString(price: total))
    }
    
    @objc func saveSlip() {
        UIImageWriteToSavedPhotosAlbum(infoView.asImage(), self, #selector(self.imageSaveCompletion(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func imageSaveCompletion(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        if let e = error {
            NotiBanner.toast(e.localizedDescription, icon: nil, type: .error)
        } else {
            NotiBanner.toast(AppUtil.shared.currentLanguage == .myanmar ? "ဘောက်ချာအား သိမ်းလိုက်ပါပြီ။" : "Slip saved to photos.", icon: nil, type: .success)
        }
    }
    
    @objc func onTappedPhone() {
        var phones: [(id: String, value: String)] = []
        AppUtil.getAppInfo()?.phoneNo.forEach { phones.append((id: "", value: $0)) }
//        Constant.AppInfo.phoneNo.forEach { phones.append((id: "", value: $0)) }
        
        ListDialog.show("Phone Numbers", items: phones, delegate: self, tapGestureDismissal: true, panGestureDismissal: true,
                    align: .centre, shouldShowArrow: true, selectedId: "")
    }
}

extension OrderHistoryDetailVC: OrderHistoryDetailDisplayLogic {
    // func didSuccess(data: <DataType>) {}
}

extension OrderHistoryDetailVC: ListDialogProtocol {
    func listDialog(didSelect title: String, id: String, value: String) {
        guard let url = URL(string: "tel://\(value)") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

