//  
//  CartOrderVC.swift
//  stationery
//
//  Created by Codigo NOL on 02/01/2021.
//

import UIKit

protocol CartOrderDisplayLogic: AnyObject {
    func didSuccessOrder(data: OrderResponse)
    func didFailOrder()
}

class CartOrderVC: BaseVC, Storyboarded {
    
    static var storyboardName: String = Constant.Storyboard.cart
    
    var router: (NSObjectProtocol & CartOrderRoutingLogic)?

    // MARK: Outlets
    @IBOutlet weak var lblTitle: LanguageLabel!
    @IBOutlet weak var lblTitleProduct: LanguageLabel!
    @IBOutlet weak var lblTitleSubTotal: LanguageLabel!
    @IBOutlet weak var stackProduct: UIStackView!
    @IBOutlet weak var lblSubTotalTitle: LanguageLabel!
    @IBOutlet weak var lblSubTotal: LanguageLabel!
    
    @IBOutlet weak var discountView: UIView!
    @IBOutlet weak var discountDivider: UIView!
    @IBOutlet weak var lblDiscountTitle: LanguageLabel!
    @IBOutlet weak var lblDiscount: LanguageLabel!
    
    @IBOutlet weak var deliveryView: UIStackView!
    @IBOutlet weak var lblDeliveryTitle: LanguageLabel!
    @IBOutlet weak var lblDeliveryFeesTitle: LanguageLabel!
    @IBOutlet weak var lblDeliveryFees: LanguageLabel!
    @IBOutlet weak var lblRegionFees: LanguageLabel!
    @IBOutlet weak var lblSelfPick: LanguageLabel!
    @IBOutlet weak var lblTotalTitle: LanguageLabel!
    @IBOutlet weak var lblTotal: LanguageLabel!
    
    @IBOutlet weak var stackPayments: UIStackView!
    @IBOutlet weak var btnPaymentInfo: LanguageButton!
    @IBOutlet weak var btnShippingInfo: LanguageButton!
    @IBOutlet weak var btnOrder: LanguageButton!

    var vm: CartOrderVM?
    var selectedPayment: PaymentType?
    var paymentViews: [PaymentTypeView] = []
    
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
        let router = CartOrderRouter()
        let vm = CartOrderVM()
        viewController.router = router
        viewController.vm = vm
        router.viewController = viewController
        vm.viewController = viewController
    }

    // MARK: View Lifecycles And View Setups
    func setupView() {
        self.hero.isEnabled = true
        btnPaymentInfo.addTarget(self, action: #selector(self.onTappedButton(_:)), for: .touchUpInside)
        btnShippingInfo.addTarget(self, action: #selector(self.onTappedButton(_:)), for: .touchUpInside)
        btnOrder.addTarget(self, action: #selector(self.onTappedButton(_:)), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setUpData()
    }
    
    func setUpData() {
        let lan = AppUtil.shared.currentLanguage
        lblTitle.changeLanguage(lan)
        lblTitleProduct.changeLanguage(lan)
        lblTitleSubTotal.changeLanguage(lan)
        lblSubTotalTitle.changeLanguage(lan)
        lblDiscountTitle.changeLanguage(lan)
        lblDeliveryTitle.changeLanguage(lan)
        lblDeliveryFeesTitle.changeLanguage(lan)
        lblRegionFees.changeLanguage(lan)
        lblSelfPick.changeLanguage(lan)
        lblTotalTitle.changeLanguage(lan)
        btnPaymentInfo.changeLanguage(lan)
        btnShippingInfo.changeLanguage(lan)
        btnOrder.changeLanguage(lan)
        
        setUpProducts()
        setUpPrice()
        setUpPayments()
    }
    
    func setUpProducts() {
        let products = ShopUtil.getSavedCart()
        
        products.forEach { item in
            let titile = "\(item.name ?? "") x \(item.quantity)"
//            let price = ShopUtil.getPrice(item.priceNormal, quantity: item.quantity, withDiscount: false)
            
            let product = ProductView()
            product.setData(title: titile, price: AppUtil.getPriceString(price: item.priceNormal))
            stackProduct.addArrangedSubview(product)
        }
    }
    
    func setUpPrice() {
        deliveryView.isHidden = true
        let lan = AppUtil.shared.currentLanguage
        
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
    }
    
    func setUpPayments() {
        let payments = ShopUtil.getPaymentType()
        
        selectedPayment = payments[0]
        for i in 0..<payments.count {
            let paymentView = PaymentTypeView()
            paymentView.setUpData(payments[i], select: i == 0)
            paymentView.delegate = self
            paymentViews.append(paymentView)
            stackPayments.addArrangedSubview(paymentView)
        }
    }
    
    @objc func onTappedButton(_ sender: UIButton) {
        switch sender {
        case btnPaymentInfo:
            guard let appInfo: AppInfo = AppUtil.getAppInfo() else { return }
            self.openURLInSafari(AppUtil.shared.currentLanguage == .myanmar ? appInfo.myanmar?.paymentLink ?? "" :
                                    appInfo.english?.paymentLink ?? "")
        case btnShippingInfo:
            guard let appInfo: AppInfo = AppUtil.getAppInfo() else { return }
            self.openURLInSafari(AppUtil.shared.currentLanguage == .myanmar ? appInfo.myanmar?.shippingLink ?? "" :
                                    appInfo.english?.shippingLink ?? "")
        case btnOrder: createOrder()
        default: break
        }
    }
    
    func createOrder() {
        if let payment = selectedPayment {
            vm?.createOrder(paymentType: payment)
        }
    }
}

extension CartOrderVC: CartOrderDisplayLogic {
    
    func didSuccessOrder(data: OrderResponse) {
        router?.routeToComplete(data: data)
    }
    
    func didFailOrder() {
        Dialog.showApiError(tryAgain: {
            self.createOrder()
        }, cancelAble: true)
    }
}

extension CartOrderVC: PaymentTypeViewProtocol {
    func paymentTypeView(onSelect data: PaymentType?) {
        self.selectedPayment = data
        for p in paymentViews {
            p.setSelected(p.data?.id == data?.id)
        }
    }
}
