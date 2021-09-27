//  
//  TabbarVM.swift
//  stationery
//
//  Created by Codigo NOL on 20/12/2020.
//

import Foundation

protocol TabbarVMBusinessLogic {
    // func getData()
}

class TabbarVM: TabbarVMBusinessLogic {

    weak var viewController: TabbarDisplayLogic?
    var worker = TabbarWorker()

    // func getData() {}
}
