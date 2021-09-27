//
//  AdsBannerCell.swift
//  stationery
//
//  Created by Codigo NOL on 13/07/2021.
//

import UIKit

class AdsBannerCell: UICollectionViewCell {
    
    @IBOutlet weak var imageSlider: ImageSliderView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(_ images: [String]) {
        imageSlider.setUpData(images: images, imageScaleMode: .scaleAspectFit)
    }

}
