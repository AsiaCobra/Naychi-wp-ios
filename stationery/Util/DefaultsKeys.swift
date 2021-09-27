//
//  DefaultKeys.swift
//  stationery
//
//  Created by Codigo NOL on 11/01/2021.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    public static let isFirstTime = DefaultsKey<Bool>("isFirstTime", defaultValue: true)
    public static let isUserLogin = DefaultsKey<Bool>("isUserLogin", defaultValue: false)
    public static let loginType = DefaultsKey<String>("loginType", defaultValue: "")
    public static let language = DefaultsKey<String>("language", defaultValue: Language.myanmar.rawValue)
    public static let musicPause = DefaultsKey<Bool>("musicPause", defaultValue:  false)
}

public enum LoginType: String {
    case facebook
    case apple
}

public enum Language: String {
    case myanmar
    case english
}

public func getLanguage() -> Language {
    return Language.init(rawValue: Defaults[key: DefaultsKeys.language]) ?? .myanmar
}

public func setLanguage(_ language: Language) {
    Defaults[key: DefaultsKeys.language] = language.rawValue
}
