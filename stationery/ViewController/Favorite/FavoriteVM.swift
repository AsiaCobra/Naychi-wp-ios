//  
//  FavoriteVM.swift
//  stationery
//
//  Created by Codigo NOL on 20/12/2020.
//

import Foundation

protocol FavoriteVMBusinessLogic {
    // func getData()
}

class FavoriteVM: FavoriteVMBusinessLogic {

    weak var viewController: FavoriteDisplayLogic?
    var worker = FavoriteWorker()

    // func getData() {}
}
