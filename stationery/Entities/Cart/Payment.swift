//
//  Payment.swift
//  stationery
//
//  Created by Codigo NOL on 07/01/2021.
//

import Foundation
import ObjectMapper
import RealmSwift

class PaymentType: Object, Mappable {
    @objc dynamic var id: String?
    @objc dynamic var desc: String?
    @objc dynamic var enabled: Bool = false
    @objc dynamic var methodDescription: String?
    @objc dynamic var methodTitle: String?
    @objc dynamic var order: Int = 0
    @objc dynamic var title: String?
    @objc dynamic var titleMm: String?
    @objc dynamic var descMm: String?
    
    public override class func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        id <- map["id"]
        desc <- map["description"]
        enabled <- map["enabled"]
        methodDescription <- map["method_description"]
        methodTitle <- map["method_title"]
        order <- map["order"]
        title <- map["title"]
        
        let paymentString = PaymentType.getTypeMm(title?.lowercased() ?? "")
        titleMm = paymentString.title
        descMm = paymentString.desc
    }
    
    public static func getTypeMm(_ payment: String) -> (title: String, desc: String) {
        var title = ""
        var desc = ""
        if payment.contains("bank transfer") {
            title = paymentTitleMm.bank.rawValue
            desc = paymentDescMm.bank.rawValue
        } else if payment.contains("check payment") {
            title = paymentTitleMm.check.rawValue
            desc = paymentDescMm.check.rawValue
        } else if payment.contains("cash on delivery") {
            title = paymentTitleMm.cod.rawValue
            desc = paymentDescMm.cod.rawValue
        }
        
        return (title: title, desc: desc)
    }
    
    enum paymentTitleMm: String {
        case bank = "ဘဏ်သို့တိုက်ရိုက်လွှဲရန်"
        case check = "ချက်လက်မှတ်ဖြင့်ပေးချေရန်"
        case cod = "အိမ်‌ရောက်မှငွေပေးချေရန်"
    }
    
    enum paymentDescMm: String {
        case bank = "ဘဏ်အကောင့်ထဲသို့ သင်၏ ငွေပေးချေမှုကို တိုက်ရိုက်ပေးဆောင်ပါ။ ကျေးဇူးပြု၍ ငွေပေးချေမှုဆောင်ရွက်ရန် အော်ဒါ နံပါတ်ကိုအသုံးပြုပေးပါ။ သင်၏ ငွေပေးချေမှု သည် ကျ‌နော်တို့ ၏ ဘဏ်အကောင့်ထဲတွင် မရောက်ရှိနေပါက ပစ္စည်းပို့ဆောင်ပေးမည်မဟုတ်ပါ။"
        case check = "ချက်လက်မှတ်အား နေခြည်ဆိုင်လိပ်စာသို့ ပို့ပေးရပါမည်။"
        case cod = "အိမ်ရောက်မှငွေသားနှင့်ပေးချေမည်။"
    }
    
}
