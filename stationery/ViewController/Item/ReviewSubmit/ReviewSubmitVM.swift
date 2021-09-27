//  
//  ReviewSubmitVM.swift
//  stationery
//
//  Created by Codigo NOL on 14/01/2021.
//

import Foundation

protocol ReviewSubmitVMBusinessLogic {
    func submitReview(_ productId: String, rating: Int, review: String)
}

class ReviewSubmitVM: ReviewSubmitVMBusinessLogic {

    weak var viewController: ReviewSubmitDisplayLogic?
    var worker = ReviewSubmitWorker()

    func submitReview(_ productId: String, rating: Int, review: String) {
        
        guard let detail = ShopUtil.getBillingDetail() else { return }
        
        let request = ReviewSubmitRequest()
        request.productId = productId
        request.rating = rating
        request.review = review
        request.reviewer = detail.name
        request.reviewerEmail = detail.email
        
        LoadingView.shared.show()
        
        worker.submitReview(request: request, completion: { (response, _) in
            LoadingView.shared.hide()
            if let response = response {
                self.viewController?.didSuccessSubmit(data: response)
            } else {
                self.viewController?.didFailSubmit()
            }
        })
    }
}
