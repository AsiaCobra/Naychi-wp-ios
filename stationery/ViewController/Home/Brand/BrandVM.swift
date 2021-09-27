//  
//  BrandVM.swift
//  stationery
//
//  Created by Codigo NOL on 20/01/2021.
//

import Foundation

protocol BrandVMBusinessLogic {
     func getBrands()
}

class BrandVM: BrandVMBusinessLogic {

    weak var viewController: BrandDisplayLogic?
    var worker = ItemWorker()
    
    let perPage = 100
    var args: Args?
    var brands: [Brand] = []
    
    func getBrands() {
        LoadingView.shared.show()
        self.getBrand(page: 1, args: args, completion: {
            self.viewController?.didSuccessBrands(data: self.brands)
        })
    }
    
    func getBrand(page: Int, args: Args?, completion: @escaping () -> Void) {
        
        if page == 1 { brands.removeAll() }
        self.args = args
        self.args?.page = page
        self.args?.per_page = perPage
        
        worker.getBrands(arg: self.args, completion: { (response, _) in
            if let response = response {
                self.brands.append(contentsOf: response)
                if response.count < self.perPage {
                    LoadingView.shared.hide()
                    completion()
                } else {
                    self.getBrand(page: page+1, args: args, completion: completion)
                }
            } else {
                LoadingView.shared.hide()
                self.viewController?.didFailBrands()
            }
        })
    }
}
