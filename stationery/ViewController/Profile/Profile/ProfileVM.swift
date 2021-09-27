//  
//  ProfileVM.swift
//  stationery
//
//  Created by Codigo NOL on 20/12/2020.
//

import Foundation
import FBSDKLoginKit
import SwiftyUserDefaults

protocol ProfileVMBusinessLogic {
    func loginWithFacebook(vc: ProfileVC, completion: @escaping (_ data: SocialAccountData?, _ error: String?) -> Void)
    func setProfileImage(_ imgView: UIImageView, _ label: UILabel)
    func createCustomer(data: SocialAccountData, loginType: LoginType)
}

class ProfileVM: ProfileVMBusinessLogic {

    weak var viewController: ProfileDisplayLogic?
    var worker = ProfileWorker()
    let loginManager = LoginManager()

    func loginWithFacebook(vc: ProfileVC, completion: @escaping (_ data: SocialAccountData?, _ error: String?) -> Void) {
        if let _ = AccessToken.current {
            // Access token available -- user already logged in
            getFacebookProfile(completion: completion)
        } else {
            // Access token not available -- user already logged out
            // Perform log in
            loginManager.logIn(permissions: ["public_profile", "email"], from: vc) { [weak self] (result, error) in
                                
                if let e = error {
                    completion(nil, e.localizedDescription)
                    return
                }
                
                if result?.isCancelled ?? false {
                    completion(nil, "Please allow permissions in Facebook.")
                    return
                }
                
                // Successfully logged in
                self?.getFacebookProfile(completion: completion)
            }
        }
    }
    
    func getFacebookProfile(completion: @escaping (_ data: SocialAccountData?, _ error: String?) -> Void) {
        GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email"]).start(completionHandler: { (connection, result, error) -> Void in
            if let e = error {
                self.loginManager.logOut()
                completion(nil, e.localizedDescription)
                return
            }
            
            if let data = result as? [String: String] { //"id, name, first_name, last_name, email"
                if (data["email"] ?? "").isEmpty {
                    self.loginManager.logOut()
                    completion(nil, "Please allow email access to register.")
                    return
                }
                
                let fbData = SocialAccountData()
                fbData.setData(id: data["id"] ?? "", name: data["name"] ?? "", firstName: data["first_name"] ?? "",
                             lastName: data["last_name"] ?? "", email: data["email"] ?? "")
                completion(fbData, nil)
            } else {
                self.loginManager.logOut()
                completion(nil, "Something went wrong. Please try again.")
            }
        })
    }
    
    func setProfileImage(_ imgView: UIImageView, _ label: UILabel) {
        guard let data = ShopUtil.getSocialAccountData() else {
            let image =  UIImage(named: "iconprofile")?.withRenderingMode(.alwaysTemplate)
            imgView.tintColor = UIColor.white
            imgView.image = image
            imgView.contentMode = .center
            return
        }
        
        if Defaults[key: DefaultsKeys.loginType] == LoginType.facebook.rawValue {
            if let id = data.id {
                imgView.setImage("https://graph.facebook.com/\(id)/picture?type=medium", completed: { success in
                    label.isHidden = success
                    if !success { self.setDefaultProfileImage(fullName: data.name ?? "", imgView: imgView, label: label) }
                })
            } else { self.setDefaultProfileImage(fullName: data.name ?? "", imgView: imgView, label: label) }
           
        } else {
            self.setDefaultProfileImage(fullName: data.name ?? "", imgView: imgView, label: label)
        }
    }
    
    func setDefaultProfileImage(fullName: String, imgView: UIImageView, label: UILabel) {
        let names = fullName.components(separatedBy: " ")
        label.text = "\(names.first?.first ?? Character(""))\(names.last?.first ?? Character(""))"
        if label.text?.isEmpty ?? true {
            let image =  UIImage(named: "iconprofile")?.withRenderingMode(.alwaysTemplate)
            imgView.tintColor = UIColor.white
            imgView.image = image
            imgView.contentMode = .center
        }
    }
    
    func createCustomer(data: SocialAccountData, loginType: LoginType) {
        
        let request = CustomerRequest()
        request.email = data.email
        request.password = nil
        request.role = "all"
        
        LoadingView.shared.show()
        worker.getCustomer(request: request, completion: { (response, _) in
            if let result = response {
                if !result.isEmpty {
                    LoadingView.shared.hide()
                    if let customer = result.first {
                        self.saveProfile(socialAccount: data, customer: customer, loginType: loginType)
                        self.viewController?.didSuccessCreateCustomer()
                    } else {
                        self.viewController?.didFailCreateCustomer()
                    }
                } else {
                    
                    let billing = Billing()
                    billing.firstName = data.name
                    billing.email = data.email
                    
                    let shipping = Shipping()
                    shipping.firstName = data.name
                    
                    let request = CustomerRequest()
                    request.email = data.email
                    request.billing = billing
                    request.firstName = data.name
                    request.username =  data.name
                    
                    self.worker.createCustomer(request: request, completion: { (response, _) in
                        LoadingView.shared.hide()
                        if let result = response {
                            self.saveProfile(socialAccount: data, customer: result, loginType: loginType)
                            self.viewController?.didSuccessCreateCustomer()
                        } else {
                            self.viewController?.didFailCreateCustomer()
                        }
                    })
                }
            } else {
                self.viewController?.didFailCreateCustomer()
            }
        })
        
    }
    
    func saveProfile(socialAccount: SocialAccountData, customer: CustomerResponse, loginType: LoginType) {
        
        Defaults[key: DefaultsKeys.isUserLogin] = true
        Defaults[key: DefaultsKeys.loginType] = loginType.rawValue
        
        ShopUtil.saveBillingDetail(name: socialAccount.name ?? "", country: "Myanmar",
                                   state: customer.billing?.state ?? "", township: customer.billing?.city ?? "",
                                   address: customer.billing?.address1 ?? "", mobile: customer.billing?.phone ?? "",
                                   email: customer.email ?? "", id: "\(customer.id ?? 0)", forceEng: true)
        ShopUtil.saveCartTotal(state: customer.billing?.state ?? "", township: customer.billing?.city ?? "")
        socialAccount.save(updatePolicy: .all)
    }
    
}
