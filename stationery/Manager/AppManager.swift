//
//  AppManager.swift
//  stationery
//
//  Created by Codigo NOL on 25/06/2021.
//

import Foundation

class AppManager {
    static let shared = AppManager()
    
    func contactUs(request: ContactUsRequest, completion: @escaping ResponseCompletionHandler) {
        APIManager.sharedInstance.sendRequest(contentType: .formUrlEncoded, method: .post, path: EndPointsNew.ContactUs,
                                              parameters: request.toJSON(), completed: completion)
    }
    
    func getAppInfo(completion: @escaping ResponseCompletionHandler) {
        APIManager.sharedInstance.sendRequest(contentType: .applicationJSON, method: .get, path: EndPointsNew.AppInfo,
                                              parameters: nil, completed: completion)
    }
    
    func getCurrentTime(completion: @escaping ResponseCompletionHandler) {
        APIManager.sharedInstance.sendRequest(contentType: .applicationJSON, method: .get, path: EndPointsNew.CurrentTime,
                                              parameters: nil, completed: completion)
    }
    
}
