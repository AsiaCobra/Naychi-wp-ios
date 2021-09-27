//
//  HomeSection.swift
//  stationery
//
//  Created by Codigo NOL on 05/01/2021.
//

import Foundation
import UIKit

//enum SectionType: String {
//    case banner = "BANNER"
//    case brand = "BRANDS"
//    case category = "CATEGORIES"
//    case productDiscount = "DISCOUNT PRODUCTS"
//    case productFeature = "FEATURED PRODUCTS"
//    case productNew = "NEW ARRIVE PRODUCTS"
//    case productBestSelling = "BEST SELLING PRODUCTS"
//    case productOther = "OTHER OFFICE PRODUCTS"
//    case none = "NONE"
//
//    func getMm() -> String {
//        switch self {
//        case .banner: return ""
//        case .brand: return "အမှတ်တံဆိပ်များ"
//        case .category: return "အမျိုးအမည်များ"
//        case .productDiscount: return "အထူးလျော့ဈေး"
//        case .productFeature: return "အထူးပစ္စည်းများ"
//        case .productNew: return "အသစ်ရောက်ပစ္စည်းများ"
//        case .productBestSelling: return "အရောင်းရဆုံးပစ္စည်းများ"
//        case .productOther: return "အခြားရုံးသုံးပစ္စည်းများ"
//        case .none: return ""
//        }
//    }
//}

class SectionHome {
    
    var index = 0
    var type = HomeSectionType.none
    var title = ""
    var titleMm = ""
    var images: [String] = []
    var cellHeight: CGFloat = 0
    var cellItemWidth: CGFloat = 0
    var headerHeight: CGFloat = 0.1
    var footerHeight: CGFloat = 0.1
    var products: [ProductResponse?] = []
    var brands: [Brand?] = []
    var args: Args?
    
    init(_ index: Int = 0, type: HomeSectionType = HomeSectionType.none, title: String = "", titleMm: String = "",
         images: [String] = [], products: [ProductResponse?] = [], brands: [Brand?] = [], args: Args? = nil) {
        self.index = index
        self.type = type
        self.images = images
        self.title = title
        self.titleMm = titleMm
        self.products = products
        self.brands = brands
        self.args = args
        
        switch type {
        case .banner:
            cellHeight = ((UIScreen.main.bounds.width*7)/18) + 40// 18:7
        case .brand:
            cellItemWidth = (UIScreen.main.bounds.width/2) - 40
            cellHeight = ((cellItemWidth*2)/3) + 20 // 3:2
            headerHeight = 64
        case .category:
            cellHeight = 120
            headerHeight = 64
        case .items:
            cellItemWidth = ((UIScreen.main.bounds.width - 50))/2
            cellHeight = (cellItemWidth*9)/5 //ratio 5:9
            headerHeight = 64
        case .none: break
        }
    }
}
