//
//  HomeProductCell.swift
//  stationery
//
//  Created by Codigo NOL on 05/01/2021.
//

import UIKit

protocol HomeProductCellProtocol: AnyObject {
    func homeProductCell(onTappedCart section: Int, itemIndex: Int, data: ProductResponse)
    func homeProductCell(onTappedItem section: Int, itemIndex: Int, data: ProductResponse)
    func homeProductCell(onTappedFav section: Int, itemIndex: Int, data: ProductResponse)
}

class HomeProductCell: UITableViewCell {
    
    @IBOutlet weak var colItems: UICollectionView!
    
    var cellWidth: CGFloat = 0
    var items: [ProductResponse?] = []
    var section = 0
    weak var delegate: HomeProductCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        colItems.delegate = self
        colItems.dataSource = self
        colItems.register(nib: ItemCell.className)
        colItems.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func setData(_ items: [ProductResponse?], cellWidth: CGFloat, section: Int) {
        self.items = items
        self.cellWidth = cellWidth
        self.section = section
        colItems.reloadData()
    }
}

extension HomeProductCell: ItemCellProtocol {
    func itemCell(onTappedCart indexPath: IndexPath, data: ProductResponse) {
        delegate?.homeProductCell(onTappedCart: section, itemIndex: indexPath.item, data: data)
    }
    
    func itemCell(onTappedItem indexPath: IndexPath, data: ProductResponse) {
        delegate?.homeProductCell(onTappedItem: section, itemIndex: indexPath.item, data: data)
    }
    
    func itemCell(onTappedFav indexPath: IndexPath, data: ProductResponse) {
        delegate?.homeProductCell(onTappedFav: section, itemIndex: indexPath.item, data: data)
    }
}

extension HomeProductCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.deque(ItemCell.self, index: indexPath)
        cell.imgItem.hero.id = "\(items[indexPath.item]?.name ?? "")\(indexPath.item)"
        cell.setData(indexPath: indexPath, data: items[indexPath.item])
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}
