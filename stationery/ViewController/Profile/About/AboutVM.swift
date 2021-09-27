//  
//  AboutVM.swift
//  stationery
//
//  Created by Codigo NOL on 11/01/2021.
//

import Foundation

protocol AboutVMBusinessLogic {
    // func getData()
}

class AboutVM: AboutVMBusinessLogic {

    weak var viewController: AboutDisplayLogic?
    var worker = AboutWorker()

    // func getData() {}
}
