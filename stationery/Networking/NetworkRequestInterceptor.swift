//
//  NetworkRequestInterceptor.swift
//  Data
//
//  Created by Codigo Phyo Thiha on 12/8/20.
//

import Foundation
import Alamofire
import SwiftyJSON

/// Request Interceptor
class NetworkRequestInterceptor: RequestInterceptor {
    
    // to store pending request
    // to retry later after access token refresh process complete
    private var requestsToRetry: [(RetryResult) -> Void] = []
    
    // to check access token refresh process state
    // process is running or not
    private var isRefreshing: Bool = false
    
    /// Intercept request and put HTTP authorization header [Basic / Auth (Bearer access_token/refresh_token)]
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        request.timeoutInterval = 180
//        if request.url?.lastPathComponent == AuthEndpoints.RefreshToken.lastPath {
//            // refresh token
//            let refreshToken = KeychainService.shared.get(key:Keys.refresh_token).orEmpty
//            request.headers.add(.authorization(bearerToken: refreshToken))
//
//        } else if [EndPoints.Login.lastPath,
//                   AuthEndpoints.RegisterManual.lastPath,
//                   AuthEndpoints.GetNewOtp.lastPath,
//                   AuthEndpoints.VerifyPin.lastPath,
//                   MiscEndPoints.Master.lastPath ].contains(request.url?.lastPathComponent) {
//            // basic auth
//            request.headers.add(.authorization(username: Tokens.Basic.userName, password: Tokens.Basic.password))
//
//        } else {
            // access token
//            let accessToken = KeychainService.shared.get(key: Keys.access_token).orEmpty
//            request.headers.add(.authorization(bearerToken: accessToken))
//        }
        
//        request.headers.add(.authorization(username: Constant.ApiCreditial.key, password: Constant.ApiCreditial.secret))
        
        completion(.success(request))
    }
    
    /// Intercept failed request and check 401 or not
    /// if 401, make refresh token process and retry all pending / failed request
    public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
//        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
//            // store failed request to retry queue later after refresh process success
//            requestsToRetry.append(completion)
//            print("retry: append")
//
//            if !isRefreshing {
//                refreshToken(session: session) { (apiResponseHandler, apiError) in
//                    print("retry: success")
//                    if apiResponseHandler.isSuccess() {
//                        // refresh process success
//                        // retry all pending / failed request
//                        // and remove from queue
//                        self.requestsToRetry.forEach { $0(.retry) }
//                        self.requestsToRetry.removeAll()
//                        print("retry: removeAll")
//                    } else {
//                        print("retry: doNotRetryWithError")
//                        completion(.doNotRetryWithError(apiError ?? error))
//                    }
//                }
//            }
//        } else {
//            print("retry: doNotRetry")
//            completion(.doNotRetryWithError(error))
//        }
        completion(.doNotRetryWithError(error))
    }
    
    /// Refresh Token Request
//    public func refreshToken(session: Session, completed: @escaping ResponseCompletionHandler) {
//        guard !isRefreshing else { return }
//        isRefreshing = true
//
//        //to do===> Add new noti
//        //NotificationCenter.default.post(name: NSNotification.Name.stopHubConnection, object: nil)
//
//        let request = session.request(AuthEndpoints.RefreshToken, method: .put, parameters: nil, encoding: ContentType.applicationJSON.encoding(), headers: nil)
//
//        request.responseJSON { (response) in
//            switch response.result {
//            case .success(let data):
//                let apiResponseHandler: ApiResponseHandler = ApiResponseHandler(json: data)
//                if apiResponseHandler.isTokenExpired() {
//                    // clear data and logout
//                    // go to login home screen
//                    RealmUtil.deleteAll()
//                    KeychainService.shared.save(key: Keys.access_token, value: "")
//                    KeychainService.shared.save(key: Keys.refresh_token, value: "")
//
//                    // clear pending / failed request from queue
//                    self.requestsToRetry.removeAll()
//
//                    let vc = UIStoryboard.init(name: "Auth", bundle: Bundle.init(identifier: AppBundle.getGo)).instantiateViewController(withIdentifier: "LoginVC")
//                    let navVC = UINavigationController(rootViewController: vc)
//                    navVC.navigationBar.isHidden = true
//                    vc.replaceRootVC(with: navVC)
//                    //UIApplication.shared.keyWindow?.rootViewController?.replaceViewController(viewController: vc)
//
//                } else if apiResponseHandler.isSuccess() {
//                    // token refresh success
//                    // save access and refresh token
//                    if let accessToken = apiResponseHandler.access_Token,
//                        let refreshToken = apiResponseHandler.refresh_Token {
//
//                        KeychainService.shared.save(key: Keys.access_token, value: accessToken)
//                        KeychainService.shared.save(key: Keys.refresh_token, value: refreshToken)
//                    }
//
//                    // notify token refresh process completed
//                    // to refresh / reconnect SignalR connection and other handling
//                    NotificationCenter.default.post(name: Notification.Name.tokenRefresh, object: nil)
//
//                    completed(apiResponseHandler, nil)
//                } else {
//                    completed(apiResponseHandler, nil)
//                }
//
//            case .failure(let error):
//                let apiResponseHandler: ApiResponseHandler = ApiResponseHandler(json: nil)
//                completed(apiResponseHandler, error)
//            }
//
//            // reset state after process finish
//            self.isRefreshing = false
//        }
//    }
}
