//
//  ImageCell.swift
//  stationery
//
//  Created by Codigo NOL on 24/12/2020.
//

import UIKit

class ImageCell: UICollectionViewCell {

    @IBOutlet weak var imageHolderView: UIView!
    
    var imageView = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.frame = CGRect(x: 0, y: 0, width: imageHolderView.frame.width, height: imageHolderView.frame.height)
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageHolderView.addSubview(imageView)
    }
    
    public func setData(_ imgUrl: String, contentMode: UIView.ContentMode = .scaleAspectFit) {
        imageView.contentMode = contentMode
        imageView.setImage(imgUrl)
        self.layoutIfNeeded()
        imageView.frame = CGRect(x: 0, y: 0, width: imageHolderView.frame.width, height: imageHolderView.frame.height)
    }

    public func strech(_ posY: CGFloat, _ height: CGFloat) {
        imageView.frame = CGRect(x: 0, y: posY, width: imageHolderView.frame.width, height: height)
    }
}
