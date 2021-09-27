//  
//  SplashVM.swift
//  stationery
//
//  Created by Codigo NOL on 20/12/2020.
//

import Foundation

protocol SplashVMBusinessLogic {
    func getMasterData()
}

class SplashVM: SplashVMBusinessLogic {

    weak var viewController: SplashDisplayLogic?
    var worker = SplashWorker()
    
    let categoryPerPage = 100
    var categoryRequest = ProductCategoryRequest()
    var categories: [ProductCategory] = []

    func getMasterData() {
        self.getAppInfo(completion: {
            self.getPaymentTypes(completion: {
                self.getProductCatagories(page: 1, completion: {
                    self.viewController?.didSuccessMasterData()
                })
            })
        })
    }
    
    func getAppInfo(completion: @escaping () -> Void) {
        worker.getAppInfo(completion: { (response, _) in
            if let response = response {
                self.saveAppInfo(appInfo: response)
                AppUtil.shared.playMusic()
                completion()
            } else {
                self.viewController?.didFailMasterData()
            }
        })
    }
    
    func saveAppInfo(appInfo: AppInfo) {
        appInfo.save(updatePolicy: .all)
        Constant.AppInfo.homeSections = appInfo.homeBlocks ?? []
        Constant.AppInfo.banners = appInfo.banners ?? []
        Constant.AppInfo.adsBanners = appInfo.adsBanners ?? []
        Constant.AppInfo.menu = appInfo.menu ?? []
        Constant.AppInfo.groupPrice = appInfo.groupPrice
        Constant.AppInfo.groupTownship = appInfo.groupTownship
        Constant.AppInfo.discountRule = appInfo.discountRules
        Constant.AppInfo.homeNoti = appInfo.noti
        
        Constant.ApiCreditial.key = appInfo.consumer_key ?? ""
        Constant.ApiCreditial.secret = appInfo.consumer_secret ?? ""
    }
    
    func getPaymentTypes(completion: @escaping () -> Void) {
        worker.getPaymentType(completion: { (response, _) in
            if let response = response {
                response.save(updatePolicy: .all)
                completion()
            } else {
                self.viewController?.didFailMasterData()
            }
        })
    }
    
    func getProductCatagories(page: Int, completion: @escaping () -> Void) {
        
        if page == 1 { categories.removeAll() }
        categoryRequest.page = page
        categoryRequest.per_page = categoryPerPage
        
        worker.getProductCatagories(request: categoryRequest, completion: { (response, _) in
            if let response = response {
                self.categories.append(contentsOf: response)
                
                if response.count < self.categoryPerPage {
                    ShopUtil.saveCategories(self.categories)
                    completion()
                } else {
                    self.getProductCatagories(page: page+1, completion: completion)
                }
            } else {
                self.viewController?.didFailMasterData()
            }
        })
    }
}
