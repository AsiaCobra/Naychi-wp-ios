//
//  CartTotal.swift
//  stationery
//
//  Created by Codigo NOL on 30/12/2020.
//

import Foundation
import RealmSwift

public class CartTotal: Object {
    
    @objc dynamic var id = "0"
    @objc dynamic var subTotal = 0
    @objc dynamic var discount = 0
    @objc dynamic var total = 0
    @objc dynamic var selfPickUp = true
    @objc dynamic var state: String?
    @objc dynamic var township: String?
    @objc dynamic var deliveryFees: Int = 0
    @objc dynamic var isInYangon: Bool = true
    @objc dynamic var paymentType: String = ""
    
    public override class func primaryKey() -> String? {
        return "id"
    }
}
