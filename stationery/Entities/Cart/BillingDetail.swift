//
//  BillingDetail.swift
//  stationery
//
//  Created by Codigo NOL on 07/01/2021.
//

import Foundation
import RealmSwift

public class BillingDetail: Object {
    
    @objc dynamic var id = "0"
    @objc dynamic var customerId: String?
    @objc dynamic var name = ""
    @objc dynamic var country = "Myanmar"
    @objc dynamic var countryMm = "မြန်မာ "
    @objc dynamic var state = ""
    @objc dynamic var township = ""
    @objc dynamic var stateMm = ""
    @objc dynamic var townshipMm = ""
    @objc dynamic var streetAddress: String = ""
    @objc dynamic var mobile: String = ""
    @objc dynamic var email: String?
    
    public override class func primaryKey() -> String? {
        return "id"
    }
}

