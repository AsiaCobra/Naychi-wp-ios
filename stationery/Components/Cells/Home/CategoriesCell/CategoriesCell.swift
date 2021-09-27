//
//  CategoriesCell.swift
//  stationery
//
//  Created by Codigo NOL on 05/01/2021.
//

import UIKit

protocol CategoriesCellProtocol: AnyObject {
    func categoriesCell(onSelect data: ProductCategory)
}

class CategoriesCell: UITableViewCell {

    @IBOutlet weak var colCatgeries: UICollectionView!
    
    var data: [ProductCategory] = []
    
    weak var delegate: CategoriesCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        data = ShopUtil.getCategories(sort: false, count: 20)
        colCatgeries.delegate = self
        colCatgeries.dataSource = self
        colCatgeries.register(nib: CategoryCell.className)
        colCatgeries.reloadData()
    }

}

extension CategoriesCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.deque(CategoryCell.self, index: indexPath)
        cell.setData(data[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.categoriesCell(onSelect: data[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

