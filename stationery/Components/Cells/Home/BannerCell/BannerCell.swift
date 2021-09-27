//
//  BannerCell.swift
//  stationery
//
//  Created by Codigo NOL on 05/01/2021.
//

import UIKit

class BannerCell: UITableViewCell {
    
    @IBOutlet weak var imageSlider: ImageSliderView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    func setData(_ images: [String]) {
        imageSlider.setUpData(images: images, imageScaleMode: .scaleAspectFit)
    }
}
