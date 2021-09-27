//
//  ColBrandCell.swift
//  stationery
//
//  Created by Codigo NOL on 20/01/2021.
//

import UIKit

class ColBrandCell: UICollectionViewCell {

    @IBOutlet weak var imgBrand: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgBrand.backgroundColor = Color.DarkGray.instance()
    }
    
    func setData(_ data: Brand?) {
        guard let brand = data else {
            imgBrand.backgroundColor = Color.DarkGray.instance()
            return
        }
        imgBrand.setImage(brand.image?.src ?? "", bgColor: .clear)
    }

}
