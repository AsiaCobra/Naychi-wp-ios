//  
//  CartVM.swift
//  stationery
//
//  Created by Codigo NOL on 20/12/2020.
//

import Foundation

protocol CartVMBusinessLogic {
    // func getData()
}

class CartVM: CartVMBusinessLogic {
    
    weak var viewController: CartDisplayLogic?
    var worker = CartWorker()
    
    func getCurrentTime() {
        LoadingView.shared.show()
        worker.getCurrentTime(completion: { (response, _) in
            LoadingView.shared.hide()
            if let date = response?.date, let dateString = response?.dateString {
                Constant.AppInfo.currentDate = date
                Constant.AppInfo.currentDateString = dateString
                self.viewController?.didSuccessCurrentTime()
            } else {
                self.viewController?.didFailedCurrentTime()
            }
        })
    }
}
