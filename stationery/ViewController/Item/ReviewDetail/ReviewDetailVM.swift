//  
//  ReviewDetailVM.swift
//  stationery
//
//  Created by Codigo NOL on 14/01/2021.
//

import Foundation

protocol ReviewDetailVMBusinessLogic {
    // func getData()
}

class ReviewDetailVM: ReviewDetailVMBusinessLogic {

    weak var viewController: ReviewDetailDisplayLogic?
    var worker = ReviewDetailWorker()

    // func getData() {}
}
