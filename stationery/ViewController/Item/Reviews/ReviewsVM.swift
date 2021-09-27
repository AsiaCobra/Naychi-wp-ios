//  
//  ReviewsVM.swift
//  stationery
//
//  Created by Codigo NOL on 15/01/2021.
//

import Foundation

protocol ReviewsVMBusinessLogic {
    // func getData()
}

class ReviewsVM: ReviewsVMBusinessLogic {

    weak var viewController: ReviewsDisplayLogic?
    var worker = ReviewsWorker()

    // func getData() {}
}
