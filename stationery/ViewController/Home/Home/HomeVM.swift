//  
//  HomeVM.swift
//  stationery
//
//  Created by Codigo NOL on 20/12/2020.
//

import Foundation
import UIKit

protocol HomeVMBusinessLogic {
    // func getData()
}

class HomeVM: HomeVMBusinessLogic {

    weak var viewController: HomeDisplayLogic?
    var worker = ItemWorker()

    let productTotals = 10
    
    func getSection() -> [SectionHome] {
        
        var sections: [SectionHome] = [SectionHome(0, type: .banner, images: Constant.AppInfo.banners)]
        var index = 1
        
        Constant.AppInfo.homeSections.forEach { sec in
            let type = HomeSectionType(rawValue: sec.type ?? "") ?? HomeSectionType.none
            switch type {
            case .banner: break
            case .brand:
                sections.append(SectionHome(index, type: type, title:  sec.titleEng ?? "", titleMm: sec.titleMm ?? "",
                                            brands: .init(repeating: nil, count: 10)))
            case .category:
                sections.append(SectionHome(index, type: type, title: sec.titleEng ?? "", titleMm: sec.titleMm ?? "", args: sec.args))
            case .items:
                sections.append(SectionHome(index, type: type, title: sec.titleEng ?? "", titleMm: sec.titleMm ?? "",
                                            products: .init(repeating: nil, count: productTotals), args: sec.args))
            case .none: break
            }
            index += 1
        }
        return sections
            
//            case .banner:
//                sections.append(SectionHome(index, type: $0, images: Constant.AppInfo.banners))
//            case .brand:
//                sections.append(SectionHome(index, type: $0, title:  $0.rawValue, titleMm: $0.getMm(),
//                                            brands: .init(repeating: nil, count: 10)))
//            case .category:
//                sections.append(SectionHome(index, type: $0, title:  $0.rawValue, titleMm: $0.getMm()))
//
//            case .productDiscount, .productFeature, .productNew, .productBestSelling, .productOther:
//                sections.append(SectionHome(index, type: $0, title: $0.rawValue, titleMm: $0.getMm(),
//                                            products: .init(repeating: nil, count: productTotals)))
    }
    
    func getProducts(sections: [SectionHome]) {
        for sec in sections {
            switch sec.type {
            case .brand:
                self.loadBrands(arg: sec.args, completion: { data in
                    if !data.isEmpty {
                        sec.brands = data
                        self.viewController?.didSuccessProducts(section: sec)
                    }
                })
            case .items:
                self.loadProucts(arg: sec.args, completion: { data in
                    if !data.isEmpty {
                        sec.products = data
                        self.viewController?.didSuccessProducts(section: sec)
                    }
                })
            case .none, .banner, .category: break
            }
        }      
    }
    
    func loadProucts(arg: Args?, completion: @escaping (_ data: [ProductResponse]) -> Void) {
        arg?.page = 1
        arg?.per_page = productTotals
        
//        switch type {
//        case .productDiscount: request.onSale = true
//        case .productFeature: request.feature = true
//        case .productNew:
//            request.order = "desc"
//            request.orderby = "date"
//        case .productBestSelling:
//            request.order = "desc"
//            request.orderby = "popularity"
//        case .productOther:
//            request.category = "147"
//        default: break
//        }
        
        worker.getProduct(arg: arg, completion: { (response, _) in
            if let response = response {
                completion(ShopUtil.setFav(response))
            } else {
                completion([])
            }
        })
    }
    
    func loadBrands(arg: Args?, completion: @escaping (_ data: [Brand]) -> Void) {
        arg?.page = 1
        arg?.per_page = 8
        
        worker.getBrands(arg: arg, completion: { (response, _) in
            if let brands = response {
                completion(brands)
            } else {
                completion([])
            }
        })
    }
}
