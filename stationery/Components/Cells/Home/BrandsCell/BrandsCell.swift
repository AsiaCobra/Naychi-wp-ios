//
//  BrandsCell.swift
//  stationery
//
//  Created by Codigo NOL on 20/01/2021.
//

import UIKit

protocol BrandsCellProtocol: AnyObject {
    func brandsCell(onSelect data: Brand)
}

class BrandsCell: UITableViewCell {

    @IBOutlet weak var colBrands: UICollectionView!
    
    var data: [Brand?] = []
    var cellWidth: CGFloat = 0
    weak var delegate: BrandsCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        colBrands.delegate = self
        colBrands.dataSource = self
        colBrands.register(nib: ColBrandCell.className)
        colBrands.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
    }
    
    func setData(_ brands: [Brand?], cellWidth: CGFloat) {
        self.data = brands
        self.cellWidth = cellWidth
        colBrands.reloadData()
    }
}

extension BrandsCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.deque(ColBrandCell.self, index: indexPath)
        cell.setData(data[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let brand = data[indexPath.item] {
            delegate?.brandsCell(onSelect: brand)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: collectionView.frame.height - 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}
