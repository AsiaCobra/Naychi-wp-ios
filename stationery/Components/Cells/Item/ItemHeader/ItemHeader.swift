//
//  ItemHeader.swift
//  stationery
//
//  Created by Codigo NOL on 07/01/2021.
//

import UIKit

protocol ItemHeaderProtocol: AnyObject {
    func itemHeader(filter show: Bool)
    func itemHeader(sort sorting: ItemSort)
    func itemHeader(filter categoryId: String, price: ItemPrice)
}

class ItemHeader: UICollectionReusableView {

    @IBOutlet weak var pickerSorting: PickerView!
    @IBOutlet weak var btnFilter: UIButton!
    
    @IBOutlet weak var stackFilter: UIStackView!
    @IBOutlet weak var pickerCategory: PickerView!
    @IBOutlet weak var pickerPrice: PickerView!
    
    weak var delegate: ItemHeaderProtocol?
    var showFilter = false
    
    var prices: [ItemPrice] = []
    var pricesDataEng: [(id: String?, value: String?)] = []
    var pricesDataMm: [(id: String?, value: String?)] = []
    var selectedPriceIndex = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    func setUpView() {
        
        pickerSorting.setData(items: ShopUtil.getSorting(), selectedIndex: 0)
        pickerSorting.delegate = self
        let categories = ShopUtil.getCategoriesForPicker()
        pickerCategory.setData(items: categories.data, selectedIndex: 0)
        pickerCategory.delegate = self
        
        let pr = ShopUtil.getPrice()
        prices = pr.prices
        pricesDataMm = pr.dataMm
        pricesDataEng = pr.dataEng
        
        pickerPrice.delegate = self
        
        btnFilter.addTarget(self, action: #selector(self.onTappedFilter), for: .touchUpInside)
    }
    
    func setUpData(showFilter: Bool) {
        self.showFilter = showFilter
        stackFilter.isHidden = !showFilter
        
        pickerPrice.setData(items: AppUtil.shared.currentLanguage == .myanmar ? pricesDataMm : pricesDataEng,
                            selectedIndex: selectedPriceIndex)
    }
    
    @objc func onTappedFilter() { delegate?.itemHeader(filter: !showFilter) }
}

extension ItemHeader: PickerViewProtocol {
    func pickerView(onSelected selectedString: String, picker: PickerView) {
        
    }
    
    func pickerView(editingDone selectedString: String?, picker: PickerView) {
        switch picker {
        case pickerSorting:
            delegate?.itemHeader(sort: ItemSort.init(rawValue: selectedString ?? "") ?? .normal)
        case pickerCategory, pickerPrice:
            
            if picker == pickerPrice {
                selectedPriceIndex = pickerPrice.getSelectedIndex() ?? 0
            }
            
            delegate?.itemHeader(
                filter: pickerCategory.getSelectedId() ?? "",
                price: prices[selectedPriceIndex]
            )
        default: break
        }
    }
}
