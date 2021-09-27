//
//  Constants.swift
//  stationery
//
//  Created by Codigo NOL on 20/12/2020.
//

import Foundation

struct Constant {
    
    struct ApiDomain {
        static let domain = "https://www.naychistationery.com"
        static let path = "/wp-json/wc"
        static let version = "/v3"
    }
    
    struct System {
        static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        static let bundleIdentifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
        static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
    
    struct Storyboard {
        static let main = "Main"
        static let home = "Home"
        static let items = "Items"
        static let favorite = "Favorite"
        static let cart = "Cart"
        static let profile = "Profile"
    }
    
    struct ApiCreditial {
        static var key = ""
        static var secret = ""
//        static let bearerToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvbmF5Y2hpc3RhdGlvbmVyeS5jb21cL21tIiwiaWF0IjoxNjI1NDYwODg5LCJuYmYiOjE2MjU0NjA4ODksImV4cCI6MTYyNjA2NTY4OSwiZGF0YSI6eyJ1c2VyIjp7ImlkIjoiMSJ9fX0.CXY3w_7qn0PcxuvMpDB0gBdt6dDea0NIzD4lTOHWpi8"
        static let username = "NayChi-IOS"
        static let password = "NayChi-IOS@2020"
    }
    
    struct ApiMessage {
        static let errorTitle = "Sorry"
        static let errorMessage = "Unable to connect internet. Please try again."
        static let errorMessageAppleID = "Fail to connect Apple Authentication Services."
        static let errorMessageAppleEmail = "Please share your email to login with apple. Please follow this step to refresh your login: go to iPhone Settings -> Apple Id -> Password & Security -> Apps Using Apple ID -> NayChi Staionery App > Stop using Apple ID."
    }
    
    struct AppInfo {
        static var homeSections: [HomeSection] = []
        static var banners: [String] = []
        static var adsBanners: [String] = []
        static var menu: [HomeMenu] = []
        static var groupPrice: GroupPrice?
        static var groupTownship: GroupTownship?
        static var discountRule: DiscountRule?
        static var currentDate: Date = Date()
        static var currentDateString: String = ""
        static var homeNoti: HomeNoti?
    }
    
    struct Message {
        static let privacy = "Your personal data will be used to process your order, support your experience throughout this website, and for other purposes described in our privacy policy."
        static let privacyMm = "သင်၏အကောင့်ကိုစီမံရန် နှင့် အချက်အလက်များကို သိမ်းထားခြင်းများအတွက် သင်၏ပုဂ္ဂိုလ်ရေးဆိုင်ရာ အချက်အလက်များကို အသုံးပြုသွားပါမည်။ privacy policy."
        static let privacyHyper = "privacy policy"
    }
}

