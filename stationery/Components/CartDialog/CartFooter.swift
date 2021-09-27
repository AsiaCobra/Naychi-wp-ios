//
//  CartFooter.swift
//  stationery
//
//  Created by Codigo NOL on 29/12/2020.
//

import UIKit

protocol CartFooterProtocol: AnyObject {
    func cartFooter(viewCart price: Int)
    func cartFooter(checkOut price: Int)
}

class CartFooter: UITableViewHeaderFooterView {
    
    @IBOutlet weak var lblPriceTitle: LanguageLabel!
    @IBOutlet weak var lblPrice: LanguageLabel!
    @IBOutlet weak var btnCart: LanguageButton!
    @IBOutlet weak var btnCheckOut: LanguageButton!
    
    weak var delegate: CartFooterProtocol?
    
    var price: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .white
        btnCart.addTarget(self, action: #selector(self.onTappedCart), for: .touchUpInside)
        btnCheckOut.addTarget(self, action: #selector(self.onTappedCheckOut), for: .touchUpInside)
    }
    
    func setData(_ price: Int) {
        self.price = price
        lblPrice.changeLanguage(AppUtil.shared.currentLanguage, title: AppUtil.getPriceString(price: price))
        
        lblPriceTitle.changeLanguage(AppUtil.shared.currentLanguage)
        btnCart.changeLanguage(AppUtil.shared.currentLanguage)
        btnCheckOut.changeLanguage(AppUtil.shared.currentLanguage)
    }
    
    @objc func onTappedCart() {
        delegate?.cartFooter(viewCart: price)
    }
    
    @objc func onTappedCheckOut() {
        delegate?.cartFooter(checkOut: price)
    }

}
