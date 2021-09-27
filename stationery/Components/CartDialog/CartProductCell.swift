//
//  CartProductCell.swift
//  stationery
//
//  Created by Codigo NOL on 29/12/2020.
//

import UIKit

protocol CartProductProtocol: AnyObject {
    func cartProduct(onDelete index: Int, data: ProductCart)
    func cartProduct(onSelect index: Int, data: ProductCart)
}

class CartProductCell: UITableViewCell {

    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblQuantity: LanguageLabel!
    @IBOutlet weak var lblPrice: LanguageLabel!
    @IBOutlet weak var lblPriceRegular: LanguageLabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnItem: UIButton!
    
    weak var delegate: CartProductProtocol?
    var index = 0
    var data = ProductCart()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        btnDelete.addTarget(self, action: #selector(self.onTappedDelete), for: .touchUpInside)
        btnItem.addTarget(self, action: #selector(self.onTappedItem), for: .touchUpInside)
    }
    
    func setData(_ data: ProductCart, index: IndexPath) {
        self.data = data
        self.index = index.row
        imgProduct.setImage(data.images.first?.src ?? "")
        lblName.text = data.name
        
        var quantityString = "\(data.quantity)"
        if AppUtil.shared.currentLanguage == .myanmar { quantityString = quantityString.mmNumbers() }
        lblQuantity.changeLanguage(AppUtil.shared.currentLanguage, title: quantityString)
        
//        if ShopUtil.hasDisscount(data.priceNormal, quantity: data.quantity) {
        if  let range = ShopUtil.getDiscountRange(brand: data.brand ?? "", quantity: data.quantity) {
            lblPriceRegular.isHidden = false
            var discount = AppUtil.getPriceString(price: data.priceNormal)
            if DiscountType.init(rawValue: range.disType) == .fixed {
                discount = AppUtil.getPriceString(price: range.disValue.toInt ?? 0)
                lblPriceRegular.changeLanguage(AppUtil.shared.currentLanguage, title: " (-\(discount))", withAni: false)
            } else {
                lblPriceRegular.changeLanguage(att: AppUtil.shared.currentLanguage, title: discount.strikeThrough())
            }
        } else {
            lblPriceRegular.attributedText = nil
            lblPriceRegular.isHidden = true
        }
        
//        let price = ShopUtil.getPrice(data.priceNormal, quantity: data.quantity)
        let price = ShopUtil.getPrice(brand: data.brand ?? "", price: data.priceNormal, quantity: data.quantity)
        lblPrice.changeLanguage(AppUtil.shared.currentLanguage, title: AppUtil.getPriceString(price: price))        
    }
    
    @objc func onTappedDelete() {
        delegate?.cartProduct(onDelete: index, data: data)
    }
    
    @objc func onTappedItem() {
        delegate?.cartProduct(onSelect: index, data: data)
    }

}
