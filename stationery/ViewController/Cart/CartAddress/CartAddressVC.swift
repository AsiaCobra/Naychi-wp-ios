//  
//  CartAddressVC.swift
//  stationery
//
//  Created by Codigo NOL on 30/12/2020.
//

import UIKit

protocol CartAddressDisplayLogic: AnyObject {
    // func didSuccess(data: <DataType>)
}

class CartAddressVC: BaseVC, Storyboarded {
    
    static var storyboardName: String = Constant.Storyboard.cart
    
    var router: (NSObjectProtocol & CartAddressRoutingLogic)?

    // MARK: Outlets
    @IBOutlet weak var imgCart: UIImageView!
    @IBOutlet weak var indicator: UIView!
    
    @IBOutlet weak var txtCoupon: TextField!
    @IBOutlet weak var btnApplyCoupon: LanguageButton!
    
    @IBOutlet weak var lblCartTotalTitle: LanguageLabel!
    @IBOutlet weak var lblSubTotalTitle: LanguageLabel!
    @IBOutlet weak var lblSubTotal: LanguageLabel!
    @IBOutlet weak var lblShippingTitle: LanguageLabel!
    @IBOutlet weak var discountView: UIView!
    @IBOutlet weak var lblDiscountTitle: LanguageLabel!
    @IBOutlet weak var lblDiscount: LanguageLabel!
    @IBOutlet weak var lblTotalTitle: LanguageLabel!
    @IBOutlet weak var lblTotal: LanguageLabel!
    @IBOutlet weak var btnNext: LanguageButton!
    
    @IBOutlet weak var imgCheckPickup: UIImageView!
    @IBOutlet weak var btnPickup: UIButton!
    @IBOutlet weak var imgCheckDelivery: UIImageView!
    @IBOutlet weak var lblSelfPickup: LanguageLabel!
    @IBOutlet weak var lblDeliveryFeeTitle: LanguageLabel!
    @IBOutlet weak var lblDeliveryFee: LanguageLabel!
    @IBOutlet weak var btnDelivery: UIButton!
    @IBOutlet weak var lblRegionalFee: LanguageLabel!

    @IBOutlet weak var addressView: UIStackView!
    @IBOutlet weak var pickerState: PickerView!
    @IBOutlet weak var pickerTownship: PickerView!

    var vm: CartAddressVM?
    var viewAppeared = false
    var data: CartTotal?
    
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
        let router = CartAddressRouter()
        let vm = CartAddressVM()
        viewController.router = router
        viewController.vm = vm
        router.viewController = viewController
        vm.viewController = viewController
    }

    // MARK: View Lifecycles And View Setups
    func setupView() {
        self.hero.isEnabled = true
//        imgCart.alpha = 0
//        indicator.alpha = 0
         
        btnApplyCoupon.changeLanguage(AppUtil.shared.currentLanguage)
        lblCartTotalTitle.changeLanguage(AppUtil.shared.currentLanguage)
        lblSubTotalTitle.changeLanguage(AppUtil.shared.currentLanguage)
        lblShippingTitle.changeLanguage(AppUtil.shared.currentLanguage)
        lblDiscountTitle.changeLanguage(AppUtil.shared.currentLanguage)
        lblTotalTitle.changeLanguage(AppUtil.shared.currentLanguage)
        btnNext.changeLanguage(AppUtil.shared.currentLanguage)
        lblSelfPickup.changeLanguage(AppUtil.shared.currentLanguage)
        lblDeliveryFeeTitle.changeLanguage(AppUtil.shared.currentLanguage)
        lblRegionalFee.changeLanguage(AppUtil.shared.currentLanguage)
        
        pickerState.delegate = self
        pickerTownship.delegate = self
        
        btnApplyCoupon.addTarget(self, action: #selector(self.onTappedButtons(_:)), for: .touchUpInside)
        btnPickup.addTarget(self, action: #selector(self.onTappedButtons(_:)), for: .touchUpInside)
        btnDelivery.addTarget(self, action: #selector(self.onTappedButtons(_:)), for: .touchUpInside)
        btnNext.addTarget(self, action: #selector(self.onTappedButtons(_:)), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setUpData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateShipping()
        if viewAppeared { return }
        viewAppeared = true
    }

    func setUpData() {
        let lan = AppUtil.shared.currentLanguage
        data = CartTotal.get()
        
        lblSubTotal.changeLanguage(lan, title: AppUtil.getPriceString(price: data?.subTotal ?? 0))
        
        discountView.isHidden = data?.discount ?? 0 <= 0
        lblDiscount.changeLanguage(lan, title: AppUtil.getPriceString(price: data?.discount ?? 0))
        
        calculateTotal(data?.state, data?.township)
        
        changeDeliveryCheck(data?.selfPickUp ?? true)
        
        let states = ShopUtil.getStates()
        let currentState = lan == .myanmar ? Region.getStateMm(data?.state ?? "Yangon") : data?.state ?? "Yangon"
        pickerState.setData(items: states)
        pickerState.setValue(currentState)
        
        pickerTownship.setData(items: ShopUtil.getTownships(currentState.isEmpty ? "Yangon" : currentState))
        let currentTown = lan == .myanmar ? Region.getTownshipMm(data?.state ?? "", data?.township ?? "") : data?.township ?? ""
        pickerTownship.setValue(currentTown)
        
        if let state = data?.state {
//            lblDeliveryFee.text = "\(Region.getFees(state, data?.township ?? "").toCurrency() ?? "0") Ks"
            lblDeliveryFee.changeLanguage(AppUtil.shared.currentLanguage, title: AppUtil.getPriceString(price: Region.getFees(state, data?.township ?? "")))
            lblRegionalFee.isHidden = state == "Yangon"
        }
    }
    
    func updateShipping() {
        guard let cart: CartTotal = CartTotal.get() else { return }
        let lan = AppUtil.shared.currentLanguage
        let currentState = lan == .myanmar ? Region.getStateMm(cart.state ?? "Yangon") : cart.state ?? "Yangon"
        let currentTown = lan == .myanmar ? Region.getTownshipMm(cart.state ?? "", cart.township ?? "") : cart.township ?? ""
        
        pickerState.setValue(currentState)
        pickerTownship.setData(items: ShopUtil.getTownships(currentState.isEmpty ? "Yangon" : currentState))
        if (cart.township ?? "").isEmpty {
            pickerTownship.reset()
        } else {
            pickerTownship.setValue(currentTown)
        }
        if let state = cart.state {
//            lblDeliveryFee.text = "\(Region.getFees(state, data?.township ?? "").toCurrency() ?? "0") Ks"
            lblDeliveryFee.changeLanguage(AppUtil.shared.currentLanguage, title: AppUtil.getPriceString(price: Region.getFees(state, data?.township ?? "")))
            lblRegionalFee.isHidden = state == "Yangon"
        }
    }
    
    func calculateTotal(_ region: String?, _ township: String?) {
        var total = data?.total ?? 0
        if !(data?.selfPickUp ?? true) {
            total += Region.getFees(region ?? "", township ?? "")
        }
        lblTotal.changeLanguage(AppUtil.shared.currentLanguage, title: AppUtil.getPriceString(price: total))
    }
    
    func setDelivery(_ selfPick: Bool) {
        saveDelivery(selfPick)
        changeDeliveryCheck(selfPick)
        calculateTotal(vm?.getStateInEng(pickerState), vm?.getTownshipInEng(pickerState, pickerTownship))
    }
    
    func saveDelivery(_ selfPick: Bool) {
        guard let data: CartTotal = CartTotal.get() else { return }
        let lan = AppUtil.shared.currentLanguage
        data.saveValue {
            data.selfPickUp = selfPick
            data.state = vm?.getStateInEng(pickerState)
            data.township = vm?.getTownshipInEng(pickerState, pickerTownship)
            data.deliveryFees = Region.getFees(vm?.getStateInEng(pickerState) ?? "", vm?.getTownshipInEng(pickerState, pickerTownship) ?? "")
            data.isInYangon = vm?.getStateInEng(pickerState) == "Yangon"
        }
        
        let currentState = pickerState.getSelectedValue() ?? ""
        let currentTown = pickerTownship.getSelectedValue() ?? ""
        
        guard let detail = ShopUtil.getBillingDetail() else {
            let d = BillingDetail()
            if lan == .myanmar {
                d.state = Region.getStateEng(currentState)
                d.township = Region.getTownshipEng(currentState, currentTown)
                d.stateMm = currentState
                d.townshipMm = currentTown
            } else {
                d.state = currentState
                d.township = currentTown
                d.stateMm = Region.getStateMm(currentState)
                d.townshipMm = Region.getTownshipMm(currentState, currentTown)
            }
            d.save()
            return
        }
        detail.saveValue {
            if lan == .myanmar {
                detail.state = Region.getStateEng(currentState)
                detail.township = Region.getTownshipEng(currentState, currentTown)
                detail.stateMm = currentState
                detail.townshipMm = currentTown
            } else {
                detail.state = currentState
                detail.township = currentTown
                detail.stateMm = Region.getStateMm(currentState)
                detail.townshipMm = Region.getTownshipMm(currentState, currentTown)
            }
        }
    }
    
    func changeDeliveryCheck(_ selfPick: Bool) {
        imgCheckPickup.image = UIImage(named: selfPick ? "iconcheckfill" : "iconcheckempty")
        imgCheckDelivery.image = UIImage(named: !selfPick ? "iconcheckfill" : "iconcheckempty")
        addressView.isHidden = selfPick
    }
    
    @objc func onTappedButtons(_ sender: UIButton) {
        self.view.endEditing(true)
        switch sender {
        case btnPickup: setDelivery(true)
        case btnDelivery: setDelivery(false)
        case btnNext:
            guard let data: CartTotal = CartTotal.get() else { return }
            if !data.selfPickUp && pickerTownship.getSelectedValue() == nil {
                pickerTownship.setErrorBorder()
                CustomAnimation.shake(view: pickerTownship)
            } else {
                router?.routeToBillingDetail()
            }
        default: break
        }
    }
}

extension CartAddressVC: CartAddressDisplayLogic {
    // func didSuccess(data: <DataType>) {}
}

extension CartAddressVC: PickerViewProtocol {
    func pickerView(onSelected selectedString: String, picker: PickerView) {
        
    }
    
    func pickerView(editingDone selectedString: String?, picker: PickerView) {
        guard let value = selectedString else { return }
        
        let state = vm?.getStateInEng(pickerState) ?? ""
        let township = vm?.getTownshipInEng(pickerState, pickerTownship) ?? ""
        let fees = Region.getFees(state, township)
        
        lblDeliveryFee.changeLanguage(AppUtil.shared.currentLanguage, title: AppUtil.getPriceString(price: fees))
        
        switch picker {
        case pickerState:
            
            lblRegionalFee.isHidden = state == "Yangon"
            
            pickerTownship.reset()
            pickerTownship.setData(items: ShopUtil.getTownships(value))
            
        case pickerTownship: break
            
        default: break
        }
        
        saveDelivery(false)
        calculateTotal(state, township)
    }
}
