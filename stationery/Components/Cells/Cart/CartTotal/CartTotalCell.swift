//
//  CartTotalCell.swift
//  stationery
//
//  Created by Codigo NOL on 30/12/2020.
//

import UIKit

protocol CartTotalCellProtocol: AnyObject {
    func cartTotalCell(checkOut subTotal: Int, discount: Int, total: Int)
}

class CartTotalCell: UITableViewCell {

    @IBOutlet weak var lblSubTotalTitle: LanguageLabel!
    @IBOutlet weak var lblSubTotal: LanguageLabel!
    @IBOutlet weak var discountView: UIView!
    @IBOutlet weak var lblDiscountTitle: LanguageLabel!
    @IBOutlet weak var lblDiscount: LanguageLabel!
    @IBOutlet weak var lblTotalTitle: LanguageLabel!
    @IBOutlet weak var lblTotal: LanguageLabel!
    @IBOutlet weak var btnChekOut: LanguageButton!
    
    weak var delegate: CartTotalCellProtocol?
    
    var total = 0
    var subTotal = 0
    var discount = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        btnChekOut.addTarget(self, action: #selector(self.onTappedCheckOut), for: .touchUpInside)
    }
    
    func setData(subTotal: Int, discount: Int, total: Int) {
        
        self.subTotal = subTotal
        self.discount = discount
        self.total = total
        
        lblSubTotalTitle.changeLanguage(AppUtil.shared.currentLanguage)
        lblDiscountTitle.changeLanguage(AppUtil.shared.currentLanguage)
        lblTotalTitle.changeLanguage(AppUtil.shared.currentLanguage)
        
        lblSubTotal.changeLanguage(AppUtil.shared.currentLanguage, title: AppUtil.getPriceString(price: subTotal))
        discountView.isHidden = discount <= 0
        lblDiscount.changeLanguage(AppUtil.shared.currentLanguage, title: AppUtil.getPriceString(price: discount))
        
//        total = subTotal
//        if discount > 0 { total -= discount }
        
        lblTotal.changeLanguage(AppUtil.shared.currentLanguage, title: AppUtil.getPriceString(price: total))
        btnChekOut.changeLanguage(AppUtil.shared.currentLanguage)
    }
    
    @objc func onTappedCheckOut() {
        delegate?.cartTotalCell(checkOut: subTotal, discount: discount, total: total)
    }
}
