//
//  CartCell.swift
//  stationery
//
//  Created by Codigo NOL on 29/12/2020.
//

import UIKit

protocol CartCellProtocol: AnyObject {
    func cartCell(onDelete index: Int, data: ProductCart)
    func cartCell(onChange quantity: Int, index: Int, data: ProductCart)
}

class CartCell: UITableViewCell {

    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPriceTitle: LanguageLabel!
    @IBOutlet weak var lblPriceRegular: LanguageLabel!
    @IBOutlet weak var lblPrice: LanguageLabel!
    @IBOutlet weak var lblQuantity: LanguageLabel!
    @IBOutlet weak var quantityView: QuantityView!
    @IBOutlet weak var lblTotalTitle: LanguageLabel!
    @IBOutlet weak var lblTotal: LanguageLabel!
    

    weak var delegate: CartCellProtocol?
    var index = 0
    var data = ProductCart()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        quantityView.setStyle(.compact)
        quantityView.roundCornerButtons(11)
        btnDelete.addTarget(self, action: #selector(self.onTappedDelete), for: .touchUpInside)
    }
    
    func setData(_ data: ProductCart, index: IndexPath) {
        self.data = data
        self.index = index.row
        imgItem.setImage(data.images.first?.src ?? "")
        lblName.text = data.name
        
        lblPriceTitle.changeLanguage(AppUtil.shared.currentLanguage)
        lblQuantity.changeLanguage(AppUtil.shared.currentLanguage)
        lblTotalTitle.changeLanguage(AppUtil.shared.currentLanguage)
        
        var fixedDiscount = 0
//        if ShopUtil.hasDisscount(data.price.value ?? 0, quantity: data.quantity) {
        if  let range = ShopUtil.getDiscountRange(brand: data.brand ?? "", quantity: data.quantity) {
//            lblPriceRegular.isHidden = false
//            lblPriceRegular.changeLanguage(att: AppUtil.shared.currentLanguage, title: AppUtil.getPriceString(price: data.priceNormal).strikeThrough())
            
            if DiscountType.init(rawValue: range.disType) == .fixed {
                lblPriceRegular.isHidden = true
                fixedDiscount = range.disValue.toInt ?? 0
            } else {
                lblPriceRegular.isHidden = false
                lblPriceRegular.changeLanguage(att: AppUtil.shared.currentLanguage, title: AppUtil.getPriceString(price: data.priceNormal).strikeThrough())
            }
            
        } else {
            lblPriceRegular.isHidden = true
        }
        
//        let price = ShopUtil.getPrice(data.priceNormal, quantity: data.quantity)
        let price = ShopUtil.getPrice(brand: data.brand ?? "", price: data.priceNormal, quantity: data.quantity)
        lblPrice.changeLanguage(AppUtil.shared.currentLanguage, title: AppUtil.getPriceString(price: price))
        
        quantityView.setQuantity(data.quantity)
        quantityView.delegate = self
        
        let total = price * data.quantity
        
        if fixedDiscount > 0 {
            let dis = AppUtil.getPriceString(price: fixedDiscount)
            lblTotal.changeLanguage(AppUtil.shared.currentLanguage, title: "(-\(dis)) \(AppUtil.getPriceString(price: total - fixedDiscount))")
        } else {
            lblTotal.changeLanguage(AppUtil.shared.currentLanguage, title: "\(AppUtil.getPriceString(price: total))")
        }
    }
    
    @objc func onTappedDelete() {
        delegate?.cartCell(onDelete: index, data: data)
    }
}

extension CartCell: QuantityViewProtocol {
    func quantityView(onSelect quantity: Int) {
        delegate?.cartCell(onChange: quantity, index: index, data: data)
    }
}
