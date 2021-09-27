//  
//  CategoryVM.swift
//  stationery
//
//  Created by Codigo NOL on 06/01/2021.
//

import Foundation

protocol CategoryVMBusinessLogic {
    // func getData()
}

class CategoryVM: CategoryVMBusinessLogic {

    weak var viewController: CategoryDisplayLogic?
    var worker = CategoryWorker()

    // func getData() {}
}
