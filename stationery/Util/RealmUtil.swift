//
//  RealmUtil.swift
//  stationery
//
//  Created by Codigo NOL on 21/12/2020.
//

import Foundation
import RealmSwift

public class RealmUtil {
    
//    public static func getEncryptionKey() -> Data {
//        let realmEncryptKey = KeychainUtil.get(key: Constants.KeychainKeys.RealmEncryptKey)
//
//        if !realmEncryptKey.isEmpty {
//
//            #if DEBUG
//                print("Realm Encrypt Key: \(realmEncryptKey)")
//            #endif
//
//            return Data.init(base64Encoded: realmEncryptKey, options: .ignoreUnknownCharacters) ?? generateEncryptionKey()
//        } else {
//            return generateEncryptionKey()
//        }
//    }
//
//    static fileprivate func generateEncryptionKey() -> Data {
//        let keyData = NSMutableData(length: 64)!
//        _ = SecRandomCopyBytes(kSecRandomDefault, 64, keyData.mutableBytes.bindMemory(to: UInt8.self, capacity: 64))
//
//        let encryptKey = keyData.base64EncodedString(options: .endLineWithLineFeed)
//        KeychainUtil.save(key: Constants.KeychainKeys.RealmEncryptKey, value: encryptKey)
//
//        return keyData as Data
//    }
    
    // https://github.com/realm/realm-cocoa/blob/master/examples/ios/swift/Encryption/ViewController.swift
    public static func getKey() -> NSData {
        // Identifier for our keychain entry - should be unique for your application
        let keychainIdentifier = Bundle.main.bundleIdentifier ?? ""
        let keychainIdentifierData = keychainIdentifier.data(using: String.Encoding.utf8, allowLossyConversion: false)!

        // First check in the keychain for an existing key
        var query: [NSString: AnyObject] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecReturnData: true as AnyObject
        ]

        // To avoid Swift optimization bug, should use withUnsafeMutablePointer() function to retrieve the keychain item
        // See also: http://stackoverflow.com/questions/24145838/querying-ios-keychain-using-swift/27721328#27721328
        var dataTypeRef: AnyObject?
        var status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
        if status == errSecSuccess {
            return dataTypeRef as! NSData
        }

        // No pre-existing key from this application, so generate a new one
        let keyData = NSMutableData(length: 64)!
        let result = SecRandomCopyBytes(kSecRandomDefault, 64, keyData.mutableBytes.bindMemory(to: UInt8.self, capacity: 64))
        assert(result == 0, "Failed to get random bytes")

        // Store the key in the keychain
        query = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecValueData: keyData
        ]

        status = SecItemAdd(query as CFDictionary, nil)
        assert(status == errSecSuccess, "Failed to insert the new key in the keychain")

        return keyData
    }
    
    public static func getConfig() -> Realm.Configuration {
        return Realm.Configuration.defaultConfiguration
    }
    
    public static func deleteAll() {
        do {
            let realm = try Realm(configuration: getConfig())
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("Realm Exception: \(error)")
        }
    }
    
    public static func deleteAll<T: Object>(_ type: T.Type) {
        do {
            let realm = try Realm(configuration: RealmUtil.getConfig())
            try realm.write {
                //                let list: [T.self] = self.getList()
                //                realm.delete(list ?? [])
                realm.delete(realm.objects(type))
            }
        } catch {
            print("Realm Delete Exception: \(error)")
        }
    }
    
}
