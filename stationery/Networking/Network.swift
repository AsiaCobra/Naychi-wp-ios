//
//  Network.swift
//  Network
//
//  Created by Codigo Kaung Soe on 03/12/2019.
//  Copyright © 2019 codigo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper
import SwiftyUserDefaults
import Reachability
import HTTPStatusCodes
import RealmSwift

public typealias CompletionHandler = (_ apiResponseHandler: ApiResponseHandler, _ error: Error?) -> Void
public typealias ResponseCompletionHandler = (_ apiResponseHandler: ApiResponseHandler, _ error: Error?) -> Void

public enum AuthorizationMethod {
    case BasicAuth
    case Bearer
    case None
}

public enum ContentType {
    case applicationJSON
    case formUrlEncoded
    
    func headers() -> [String: String] {
        switch self {
        case .applicationJSON:
            return ["Content-Type": "application/json"]
        case .formUrlEncoded:
            return ["Content-Type": "application/x-www-form-urlencoded"]
        }
    }
    
    func encoding() -> ParameterEncoding {
        switch self {
        case .applicationJSON:
            return JSONEncoding.default
        case .formUrlEncoded:
            return URLEncoding(destination: .httpBody, arrayEncoding: .noBrackets, boolEncoding: .literal)
        }
    }
}

open class APIManager {
    // Singleton
    public static let sharedInstance = APIManager()
    private var alamofireSession: Session!
    private var networkInterceptor = NetworkRequestInterceptor()
    
    init() {
        print("retry: apimanager init")
        let manager = ServerTrustManager(allHostsMustBeEvaluated: false, evaluators: ["www.naychistationery.com": DisabledTrustEvaluator()])
        alamofireSession = Session(interceptor: networkInterceptor, serverTrustManager: manager)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(tokenRefreshRequireLisener), name: NSNotification.Name.tokenRefresh, object: nil)
    }
    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
    
    public func sendRequest(contentType: ContentType = .applicationJSON,
                            method: HTTPMethod,
                            path: URLConvertible,
                            parameters: [String: Any]?,
                            completed: @escaping ResponseCompletionHandler,
                            headers:[String:String]? = nil) {
        
        var encoding: ParameterEncoding!
        var request: DataRequest!
        let updatedParams = parameters
        
//        if updatedParams == nil { updatedParams = BaseRequestData().toJSON() }
        
        switch method {
        case .get, .delete:
            encoding = URLEncoding(destination: .queryString, arrayEncoding: .noBrackets, boolEncoding: .literal)
        default:
            encoding = contentType.encoding()
        }
        
        var header = headers
        if header == nil{
//            let token = Data("\(Constant.ApiCreditial.key):\(Constant.ApiCreditial.secret)".utf8).base64EncodedString()
//            header = ["Authorization": "Basic \(token)"]
            if contentType == .formUrlEncoded {
//                header = ["Authorization": "Bearer \(Constant.ApiCreditial.bearerToken)"]
            } else {
                header = ["Content-Type": "application/json"]
            }
        }
        
        if isDebug {
            do {
                try print("debug:", "api ->", path.asURL().absoluteString)
            } catch {
                print("debug:", "api ->", "URL Invalid")
            }
        }
        
//        request = alamofireSession.request(path, method: method, parameters: updatedParams, encoding: encoding, headers: HTTPHeaders(header ?? [:])).authenticate(username: Constant.ApiCreditial.key, password: Constant.ApiCreditial.secret)
        
        
        request = alamofireSession.request(path, method: method, parameters: updatedParams, encoding: encoding, headers: HTTPHeaders(header ?? [:]))
        sendJSONRequest(request: request, completed: completed)
    }
    
    /// File Upload - single data upload
//    public func uploadRequest(uploadData: Data, name: String, method: HTTPMethod, path: URLConvertible, completed: @escaping ResponseCompletionHandler) {
//
//       // SwiftyBeaver.requestLog(path: path, method: method, param: nil)
//
//        alamofireSession.upload(multipartFormData: { multiPartFormData in
//            multiPartFormData.append(uploadData, withName: name, fileName: "\(UUID().uuidString).jpeg", mimeType: "image/jpeg")
//
//        }, to: path,headers: HTTPHeaders(generateHeader())).validate(statusCode: 200..<300).responseJSON { (response) in
//
//            //SwiftyBeaver.responseLog(path: path, response: response)
//
//            switch response.result {
//            case .success(let data):
//                if let rsp = response.response {
//                    if let statusCode = HTTPStatusCode(rawValue: rsp.statusCode) {
//                        if statusCode.isSuccess {
//                            let apiResponseHandler: ApiResponseHandler = ApiResponseHandler(json: data)
//                            completed(apiResponseHandler, nil)
//                        } else {
//                            let apiResponseHandler: ApiResponseHandler = ApiResponseHandler(json: data)
//                            completed(apiResponseHandler, nil)
//                        }
//                    }
//                }
//            case .failure(let error):
//                let apiResponseHandler: ApiResponseHandler = ApiResponseHandler(json: nil)
//                completed(apiResponseHandler, error)
//            }
//        }
//    }
    
    
    /// Common JSON Request
    private func sendJSONRequest(request: DataRequest, completed: @escaping ResponseCompletionHandler) {
        
        request.validate(statusCode: 200..<300).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                if let rsp = response.response {
                    if let statusCode = HTTPStatusCode(rawValue: rsp.statusCode) {
                        if statusCode.isSuccess {
                            let apiResponseHandler: ApiResponseHandler = ApiResponseHandler(json: data)
                            if isDebug { print("debug:", "api ->", apiResponseHandler.data as Any) }
                            completed(apiResponseHandler, nil)
                        } else {
                            let apiResponseHandler: ApiResponseHandler = ApiResponseHandler(json: data)
                            if isDebug { print("debug:", "api ->", apiResponseHandler.data as Any) }
                            completed(apiResponseHandler, nil)
                        }
                    }
                }
            case .failure(let error):
                let apiResponseHandler: ApiResponseHandler = ApiResponseHandler(json: nil)
                if isDebug { print("debug:", "api ->", error.localizedDescription) }
                completed(apiResponseHandler, error)
            }
        }
    }
    
    private func sendUploadRequest(request: UploadRequest, completed: @escaping ResponseCompletionHandler) {
        request.validate(statusCode: 200..<300).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                if let rsp = response.response {
                    if let statusCode = HTTPStatusCode(rawValue: rsp.statusCode) {
                        if statusCode.isSuccess {
                            let apiResponseHandler: ApiResponseHandler = ApiResponseHandler(json: data)
                            completed(apiResponseHandler, nil)
                        } else {
                            let apiResponseHandler: ApiResponseHandler = ApiResponseHandler(json: data)
                            completed(apiResponseHandler, nil)
                        }
                    }
                }
            case .failure(let error):
                let apiResponseHandler: ApiResponseHandler = ApiResponseHandler(json: nil)
                completed(apiResponseHandler, error)
            }
        }
    }
    
    /// Update new fcm token to server
//    public func updateDeviceToken() {
//        if !KeychainUtil.getAccessToken().isEmpty {
//            guard let pushToken = KeychainUtil.getPushToken() else { return }
//            let deviceToken = pushToken
//            let deviceType = "2"
//            let parameters = ["deviceToken": deviceToken, "deviceType": deviceType]
//
//            sendRequest(method: .put, path: AuthEndpoints.UpdateDevice, parameters: parameters) { (apiResponseHandler, error) in
//                if apiResponseHandler.isSuccess() {
//                    Defaults[.newPushTokenIsAvailable] = false
//                }
//            }
//        }
//    }
    
    /// token refresh process from api manager singleton  - lisener method for signalr
//    @objc private func tokenRefreshRequireLisener() {
//       refreshToken(isSuccess: nil, failed: nil)
//    }
    
    /// token refresh process from api manager singleton  - public method with succes / fail callback
//    public func refreshToken(isSuccess: (() -> Void)?, failed: ((_ errorMessage: String?) -> Void)?) {
//        networkInterceptor.refreshToken(session: alamofireSession) { (apiResponseHandler, error) in
//            if apiResponseHandler.isSuccess() {
//                isSuccess?()
//            } else {
//                failed?(apiResponseHandler.errorMessage())
//            }
//        }
//    }
}
