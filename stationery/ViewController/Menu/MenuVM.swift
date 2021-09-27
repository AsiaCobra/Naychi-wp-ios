//  
//  MenuVM.swift
//  stationery
//
//  Created by Codigo NOL on 20/12/2020.
//

import Foundation

protocol MenuVMBusinessLogic {
    // func getData()
}

class MenuVM: MenuVMBusinessLogic {

    weak var viewController: MenuDisplayLogic?
    var worker = MenuWorker()

    // func getData() {}
}
