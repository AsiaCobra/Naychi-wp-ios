//  
//  OrderCompleteVC.swift
//  stationery
//
//  Created by Codigo NOL on 07/01/2021.
//

import UIKit

protocol OrderCompleteDisplayLogic: AnyObject {
    // func didSuccess(data: <DataType>)
}

class OrderCompleteVC: BaseVC, Storyboarded {
    
    static var storyboardName: String = Constant.Storyboard.cart
    
    var router: (NSObjectProtocol & OrderCompleteRoutingLogic)?

    // MARK: Outlets
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var lblOrderNo: LanguageLabel!
    @IBOutlet weak var lblDate: LanguageLabel!
    @IBOutlet weak var lblTotalTop: LanguageLabel!
    @IBOutlet weak var lblPaymentMethod: LanguageLabel!
    
    @IBOutlet weak var stackProduct: UIStackView!
    @IBOutlet weak var lblSubTotal: LanguageLabel!
    
    @IBOutlet weak var discountView: UIView!
    @IBOutlet weak var discountDivider: UIView!
    @IBOutlet weak var lblDiscount: LanguageLabel!
    
    @IBOutlet weak var deliveryView: UIStackView!
    @IBOutlet weak var lblDeliveryFees: LanguageLabel!
    @IBOutlet weak var lblRegionFees: LanguageLabel!
    @IBOutlet weak var lblSelfPick: LanguageLabel!
    
    @IBOutlet weak var lblPayment: LanguageLabel!
    @IBOutlet weak var lblTotal: LanguageLabel!
    
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var btnSaveSlip: UIButton!
    @IBOutlet weak var btnBackToShop: UIButton!

    var vm: OrderCompleteVM?
    var navi: UINavigationController?
    var data: OrderResponse?
    
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
        let router = OrderCompleteRouter()
        let vm = OrderCompleteVM()
        viewController.router = router
        viewController.vm = vm
        router.viewController = viewController
        vm.viewController = viewController
    }

    // MARK: View Lifecycles And View Setups
    func setupView() {
        btnCross.addTarget(self, action: #selector(self.quit), for: .touchUpInside)
        btnSaveSlip.addTarget(self, action: #selector(self.saveSlip), for: .touchUpInside)
        btnBackToShop.addTarget(self, action: #selector(self.quit), for: .touchUpInside)
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
        
        let products = ShopUtil.getSavedCart()
        
        products.forEach { item in
            let titile = "\(item.name ?? "") x \(item.quantity)"
//            let price = ShopUtil.getPrice(item.priceNormal, quantity: item.quantity, withDiscount: false)
            let product = ProductView()
            product.setData(title: titile, price: AppUtil.getPriceString(price: item.priceNormal))
            stackProduct.addArrangedSubview(product)
        }
        
        deliveryView.isHidden = true
        
        guard let cartTotal: CartTotal = CartTotal.get() else { return }
        lblSubTotal.changeLanguage(lan, title: AppUtil.getPriceString(price: cartTotal.subTotal))
        
        discountView.isHidden = cartTotal.discount <= 0
        discountDivider.isHidden = discountView.isHidden
        lblDiscount.changeLanguage(lan, title: AppUtil.getPriceString(price: cartTotal.discount))
        
        deliveryView.isHidden = cartTotal.selfPickUp
        lblDeliveryFees.changeLanguage(lan, title: AppUtil.getPriceString(price: cartTotal.deliveryFees))
        lblRegionFees.isHidden = cartTotal.isInYangon
        
        lblSelfPick.isHidden = !cartTotal.selfPickUp
        
        let total = cartTotal.selfPickUp ? cartTotal.total : cartTotal.total + cartTotal.deliveryFees
        lblTotal.changeLanguage(lan, title: AppUtil.getPriceString(price: total))
        lblTotalTop.changeLanguage(lan, title: AppUtil.getPriceString(price: total))
        
        ShopUtil.clearCart()
    }
    
    @objc func quit() {
        self.navi?.popToRootViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
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
}

extension OrderCompleteVC: OrderCompleteDisplayLogic {
    // func didSuccess(data: <DataType>) {}
}
