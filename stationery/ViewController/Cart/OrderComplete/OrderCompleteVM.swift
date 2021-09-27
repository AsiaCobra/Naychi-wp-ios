//  
//  OrderCompleteVM.swift
//  stationery
//
//  Created by Codigo NOL on 07/01/2021.
//

import Foundation

protocol OrderCompleteVMBusinessLogic {
    // func getData()
}

class OrderCompleteVM: OrderCompleteVMBusinessLogic {

    weak var viewController: OrderCompleteDisplayLogic?
    var worker = OrderCompleteWorker()

    // func getData() {}
}
