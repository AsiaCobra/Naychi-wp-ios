//  
//  CartOrderVM.swift
//  stationery
//
//  Created by Codigo NOL on 02/01/2021.
//

import Foundation

protocol CartOrderVMBusinessLogic {
    // func getData()
}

class CartOrderVM: CartOrderVMBusinessLogic {

    weak var viewController: CartOrderDisplayLogic?
    var worker = CartOrderWorker()

    func createOrder(paymentType: PaymentType) {
        let request = OrderRequest()
        
        request.paymentMethod = paymentType.id
        request.paymentMethodTitle = paymentType.methodTitle
        request.setPaid = false
        request.billing = getBilling()
        request.shipping = getShipping()
        request.items = getItems()
        request.shippingLines = getShippingLine()
        request.customer = ShopUtil.getBillingDetail()?.customerId?.toInt ?? 0
        
        LoadingView.shared.show()
        worker.createOrder(request: request, completion: { (response, _) in
            LoadingView.shared.hide()
            if let response = response {
                self.viewController?.didSuccessOrder(data: response)
            } else {
                self.viewController?.didFailOrder()
            }
        })
    }
    
    func getBilling() -> Billing? {
        guard let detail = ShopUtil.getBillingDetail() else { return nil }
        let billing = Billing()
        billing.firstName = detail.name
//        billing.lastName
        billing.address1 = detail.streetAddress
//        billing.address2
        billing.city = detail.township
        billing.state = detail.state
//        billing?.postcode
        billing.country = "MM"
        billing.email = detail.email
        billing.phone = detail.mobile
        return billing
    }
    
    func getShipping() -> Shipping? {
        guard let detail = ShopUtil.getBillingDetail() else { return nil }
        guard let cartTotal: CartTotal = CartTotal.get() else { return nil }
        
        let shipping = Shipping()
        shipping.firstName = detail.name
//        shipping.lastName
        shipping.address1 = detail.streetAddress
//        shipping.address2
        shipping.city = cartTotal.township
        shipping.state = cartTotal.state
//        shipping.postcode
        shipping.country = "MM"
        return shipping
    }
    
    func getItems() -> [OrderItem] {
        var orderItem: [OrderItem] = []
        
        for item in ShopUtil.getSavedCart() {
            let order = OrderItem()
            order.productId = item.id.toInt
            order.quantity = item.quantity
            if let total = getTotalAfterDiscount(item: item) {
                order.subtotal = "\(total)"
                order.total = "\(total)"
            }
            orderItem.append(order)
        }
        
        return orderItem
    }
    
    func getTotalAfterDiscount(item: ProductCart) -> Int? {
        guard let range = ShopUtil.getDiscountRange(brand: item.brand ?? "", quantity: item.quantity),
              let disType = DiscountType(rawValue: range.disType), let disValue = range.disValue.toInt else { return nil }
        return ShopUtil.getPrice(type: disType, discount: disValue, price: item.priceNormal, quantity: item.quantity)
    }
    
    func getShippingLine() -> [ShippingLine]? {
        guard let cartTotal: CartTotal = CartTotal.get() else { return nil }
        if cartTotal.selfPickUp { return nil }
        
//        {
//            "method_id": "flat_rate",
//            "method_title": "Flat Rate",
//            "total": "10.00"
//        }
        let ship = ShippingLine()
        ship.methodId = "flat_rate"
        ship.methodTitle = "Flat Rate"
        ship.total = "\(cartTotal.deliveryFees)"
        return [ship]
    }
}
