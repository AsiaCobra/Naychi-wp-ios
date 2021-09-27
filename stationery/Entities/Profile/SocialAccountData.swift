//
//  FacebookData.swift
//  stationery
//
//  Created by Codigo NOL on 12/01/2021.
//

import Foundation
import RealmSwift

class SocialAccountData: Object {
    @objc dynamic var id: String?
    @objc dynamic var name: String?
    @objc dynamic var firstName: String?
    @objc dynamic var lastName: String?
    @objc dynamic var email: String?
    
    public override class func primaryKey() -> String? { return "id" }
    
    func setData(id: String, name: String, firstName: String, lastName: String, email: String) {
        self.id = id
        self.name = name
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
}
