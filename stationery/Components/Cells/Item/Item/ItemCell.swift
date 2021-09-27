//
//  ItemCell.swift
//  stationery
//
//  Created by Codigo NOL on 22/12/2020.
//

import UIKit
import Kingfisher

protocol ItemCellProtocol: AnyObject {
    func itemCell(onTappedCart indexPath: IndexPath, data: ProductResponse)
    func itemCell(onTappedItem indexPath: IndexPath, data: ProductResponse)
    func itemCell(onTappedFav indexPath: IndexPath, data: ProductResponse)
}

class ItemCell: UICollectionViewCell {

    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblPrice: LanguageLabel!
    @IBOutlet weak var btnCard: UIButton!
    @IBOutlet weak var btnItem: UIButton!
    
    var data: ProductResponse?
    var indexPath = IndexPath(row: 0, section: 0)
    weak var delegate: ItemCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnItem.addTarget(self, action: #selector(self.onTappedButton(_:)), for: .touchUpInside)
        btnCard.addTarget(self, action: #selector(self.onTappedButton(_:)), for: .touchUpInside)
        btnFav.addTarget(self, action: #selector(self.onTappedButton(_:)), for: .touchUpInside)
    }

    func setData(indexPath: IndexPath, data: ProductResponse?) {
        
        guard let product = data else {
            lblTitle.text = "...."
            lblDesc.text = "..........."
            lblPrice.text = "......."
            imgItem.image = nil
            imgItem.backgroundColor = Color.Gray.instance()
            return
        }
        
        self.indexPath = indexPath
        self.data = product
        lblTitle.text = product.categories?.first?.name
        lblDesc.text = product.name
        lblPrice.changeLanguage(AppUtil.shared.currentLanguage,
                                title: AppUtil.shared.currentLanguage == .myanmar ? product.priceMm : product.priceEng)
        
        imgItem.contentMode = .scaleAspectFit
        imgItem.setImage(product.images?.first?.src ?? "")
        
        btnFav.setImage(UIImage(named: data?.isFavorite ?? false ? "iconheartfill" : "iconheartempty"), for: .normal)
    }
    
    @objc func onTappedButton(_ sender: UIButton) {
        guard let product = data else { return }
        switch sender {
        case btnFav: delegate?.itemCell(onTappedFav: indexPath, data: product)
        case btnCard: delegate?.itemCell(onTappedCart: indexPath, data: product)
        case btnItem: delegate?.itemCell(onTappedItem: indexPath, data: product)
        default: break
        }
    }
}
