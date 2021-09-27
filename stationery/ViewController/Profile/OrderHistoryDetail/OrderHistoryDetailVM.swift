//  
//  OrderHistoryDetailVM.swift
//  stationery
//
//  Created by Codigo NOL on 26/06/2021.
//

import Foundation

protocol OrderHistoryDetailVMBusinessLogic {
    // func getData()
}

class OrderHistoryDetailVM: OrderHistoryDetailVMBusinessLogic {

    weak var viewController: OrderHistoryDetailDisplayLogic?
    var worker = OrderHistoryDetailWorker()

    // func getData() {}
}
