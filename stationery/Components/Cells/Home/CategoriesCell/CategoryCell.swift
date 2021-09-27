//
//  CategoryCell.swift
//  stationery
//
//  Created by Codigo NOL on 05/01/2021.
//

import UIKit

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setData(_ data: ProductCategory) {
        imgCategory.setImage(data.image?.src ?? "")
        lblTitle.text = data.name
    }
}
