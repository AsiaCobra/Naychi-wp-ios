//  
//  ContactUsWorker.swift
//  stationery
//
//  Created by Codigo NOL on 16/01/2021.
//

import Foundation
import ObjectMapper

class ContactUsWorker {
    func contactUs(request: ContactUsRequest, completion: @escaping (_ response: [ProductCategory]?, _ errorMessage: String?) -> Void) {
        AppManager.shared.contactUs(request: request, completion: { (apiResponseHandler, error) in
            completion(nil, error?.localizedDescription)
        })
        
    }
}
