//
//  FavoriteCell.swift
//  stationery
//
//  Created by Codigo NOL on 03/01/2021.
//

import UIKit

protocol FavoriteCellProtocol: AnyObject {
    func favoriteCell(onTappedCart index: Int, data: ProductFav)
    func favoriteCell(onTappedItem index: Int, data: ProductFav)
    func favoriteCell(onTappedFav index: Int, data: ProductFav)
}


class FavoriteCell: UITableViewCell {

    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var lblTitle: LanguageLabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblPrice: LanguageLabel!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var btnItem: UIButton!
    
    var data: ProductFav?
    var index = 0
    weak var delegate: FavoriteCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        btnItem.addTarget(self, action: #selector(self.onTappedButton(_:)), for: .touchUpInside)
        btnCart.addTarget(self, action: #selector(self.onTappedButton(_:)), for: .touchUpInside)
        btnFav.addTarget(self, action: #selector(self.onTappedButton(_:)), for: .touchUpInside)
    }
    
    func setData(index: Int, data: ProductFav) {
        
        self.index = index
        self.data = data
        lblTitle.text = data.categories.first?.name
        lblDesc.text = data.name
        lblPrice.changeLanguage(AppUtil.shared.currentLanguage,
                                title: AppUtil.shared.currentLanguage == .myanmar ? data.priceMm : data.priceEng)
        
        imgItem.contentMode = .scaleAspectFit
        imgItem.setImage(data.images.first?.src ?? "")
        
    }
    
    @objc func onTappedButton(_ sender: UIButton) {
        guard let product = data else { return }
        switch sender {
        case btnFav: delegate?.favoriteCell(onTappedFav: index, data: product)
        case btnCart: delegate?.favoriteCell(onTappedCart: index, data: product)
        case btnItem: delegate?.favoriteCell(onTappedItem: index, data: product)
        default: break
        }
    }
    
}
