//
//  ApiResponseHandler.swift
//  Networking
//
//  Created by Codigo NOL on 02/01/2020.
//  Copyright © 2020 codigo. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct ApiResponseHandler {
    
    
//    {
//        "code": "woocommerce_rest_cannot_view",
//        "message": "Sorry, you cannot list resources.",
//        "data": {
//            "status": 401
//        }
//    }
    
    var data: JSON?
    
    // Server Error Handling
//    var server_error_code: Int?
//    var server_error_message: String?
    
    // Business Error Handling
//    var error_message: String?
//    var error_code: Int?
    
    // Token
//    var access_Token: String?
//    var refresh_Token: String?
    
    
    init(json: Any?) {
//        if let js = json {
//            self.jsonObject = js
//
//            let json = JSON(js)
//            self.data = json["data"]
//
//            self.error_code = json["data"]["data_error_code"].int
//            self.error_message = json["data"]["data_error_msg"].string
//            self.server_error_code = json["error_code"].int
//            self.server_error_message = json["error_msg"].string
//
//            self.access_Token = json["data"]["data"]["accessToken"].string
//            self.refresh_Token = json["data"]["data"]["refreshToken"].string
//        }
        if let js = json {
            self.data = JSON(js)
        }
    }
    
    public func isSuccess() -> Bool {
//        if let serverErrorCode = server_error_code, let dataErrorCode = error_code {
//            return serverErrorCode == 0 && dataErrorCode == 0
//        }
        
        return !(data == nil)
    }
    
//    public func isTokenExpired() -> Bool {
//        if let code = server_error_code {
//            if code == 401 || code == 498 {
//                return true
//            }
//        }
//
//        return false
//    }
//
//    public func errorMessage() -> String {
//        return dataErrorMessage() ?? serverErrorMessage()
//    }
//
//    public func dataErrorMessage() -> String? {
//        return error_message
//    }
//
//    public func serverErrorMessage() -> String {
//        guard let msg = server_error_message else {
//            return ErrorMessages.commonError.message()
//        }
//        return msg
//    }
}
