//  
//  ItemDetailVM.swift
//  stationery
//
//  Created by Codigo NOL on 24/12/2020.
//

import Foundation

protocol ItemDetailVMBusinessLogic {
    func getRelatedProduct()
    func getReviews(_ productId: String)
}

class ItemDetailVM: ItemDetailVMBusinessLogic {

    weak var viewController: ItemDetailDisplayLogic?
    var worker = ItemDetailWorker()

    var productIds: [Int] = []
    var productCount = 0
    var reviewLoadCount = 0
    
    func getRelatedProduct() {
        
        if productCount > productIds.count - 1 { return }
        
        worker.getProduct(id: "\(productIds[productCount])", completion: { (response, _) in
            if let response = response {
                self.productCount += 1
                self.viewController?.didSuccessRelatedProduct(data: response, index: self.productCount-1)
            } else {
                self.viewController?.didFailedRelatedProduct()
            }
        })
    }
    
    func getReviews(_ productId: String) {
        if reviewLoadCount > 3 { return }
        
        worker.getProduct(id: productId, completion: { (response, _) in
            if let product = response {
                
                let request = ReviewRequest()
                request.product = productId
                self.worker.getReviews(request: request, completion: { (response, _) in
                    if let reviews = response {
                        self.viewController?.didSuccesReview(data: reviews, product: product)
                    } else {
                        self.reviewLoadCount += 1
                        self.getReviews(productId)
                    }
                })
                
            } else {
                self.reviewLoadCount += 1
                self.getReviews(productId)
            }
        })
        
    }
    
    func getCurrentTime() {
        LoadingView.shared.show()
        worker.getCurrentTime(completion: { (response, _) in
            LoadingView.shared.hide()
            if let date = response?.date, let dateString = response?.dateString {
                Constant.AppInfo.currentDate = date
                Constant.AppInfo.currentDateString = dateString
                self.viewController?.didSuccessCurrentTime()
            } else {
                self.viewController?.didFailedCurrentTime()
            }
        })
    }
    
    func getDiscount(normalPrice: Int?, brands: [BaseItem]?) -> [DiscountModel] {
        
        guard let price = normalPrice, price > 0, let brand = brands?.first?.slug,
              let rule = ShopUtil.getDiscountRule(brand: brand) else {
            return []
        }
        
        var models: [DiscountModel] = []
        
        rule.discountRanges?.forEach({ range in
            if let type = DiscountType.init(rawValue: range.disType.lowercased()) {
                var title = "\(range.startRange)"
                title.append(range.endRange.isEmpty ? "+" : " - \(range.endRange)" )
                let discount = ShopUtil.getPrice(type: type, discount: range.disValue.toInt ?? 0, price: price, quantity: 1)
                models.append(DiscountModel(titleEng: title, titleMm: title.mmNumbers(),
                                            discount: type == .fixed ? "-\(range.disValue)" : "\(discount)", type: type))
            }
        })
        return models
    }
}
