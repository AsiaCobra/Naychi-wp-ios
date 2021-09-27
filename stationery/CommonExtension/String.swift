//
//  String.swift
//  ComfortDelGro
//
//  Created by Aung Htoo Myat Khaing on 8/20/18.
//  Copyright © 2018 Codigo. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto

public enum DateFormat: String {
    /** yyyy-MM-dd HH:mm:ss */
    case type1 = "yyyy-MM-dd HH:mm:ss"
    /**  yyyy-MM-dd HH:mm */
    case type2 = "yyyy-MM-dd HH:mm"
    
    func toString() -> String {
        return self.rawValue
    }
}

public extension String {
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    static var empty = ""
    
    func strikeThrough() -> NSAttributedString {
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    var removedSpace: String {
        return self.replacingOccurrences(of: " ", with: "")
    }
	
	var removedDot: String {
		return self.replacingOccurrences(of: ".", with: "")
	}
    
    var url: URL? {
        return URL(string: self)
    }
    
    var toInt: Int? {
        return Int(self)
    }
    
    var toDouble: Double? {
        return Double(self)
    }
    
    // https://stackoverflow.com/a/34423577/3378606
    func height(for width: CGFloat, font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let actualSize = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font], context: nil)
        return actualSize.height
    }
    
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = from16.samePosition(in: self),
            let to = to16.samePosition(in: self)
            else { return nil }
        return from ..< to
    }
    
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
    
    func toIntFlag() -> Int? {
        switch self {
        case "True", "true", "yes", "1":
            return 1
        case "False", "false", "no", "0":
            return 0
        default:
            return nil
        }
    }
    
    func substring(from: Int?, to: Int?) -> String {
        if let start = from {
            guard start < self.count else {
                return ""
            }
        }
        
        if let end = to {
            guard end >= 0 else {
                return ""
            }
        }
        
        if let start = from, let end = to {
            guard end - start >= 0 else {
                return ""
            }
        }
        
        let startIndex: String.Index
        if let start = from, start >= 0 {
            startIndex = self.index(self.startIndex, offsetBy: start)
        } else {
            startIndex = self.startIndex
        }
        
        let endIndex: String.Index
        if let end = to, end >= 0, end < self.count {
            endIndex = self.index(self.startIndex, offsetBy: end + 1)
        } else {
            endIndex = self.endIndex
        }
        
        return String(self[startIndex ..< endIndex])
    }
    
    // Helpers
    // Convert from 14:00(YGN) to 7:30(UTC)
    func convertToUTCTimestamp() -> String? {
        let strArr: [String] = self.components(separatedBy: ":")
        guard strArr.count > 1 else {
            return nil
        }
        
        let int0 = Int(strArr[0])
        let int1 = Int(strArr[1])
        let calendar = Calendar.current
        let today = Date()
        
        let com = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: today)
        
        var newcom = DateComponents()
        newcom.year = com.year
        newcom.month = com.month
        newcom.day = com.day
        newcom.hour = int0
        newcom.minute = int1
        let newcomdate = calendar.date(from: newcom)!
        
        let finalf = DateFormatter()
        finalf.dateFormat = "HH:mm"
        finalf.timeZone = TimeZone(abbreviation: "UTC")
        let finalfString = finalf.string(from: newcomdate)
        return finalfString
    }
    
    // Convert from 7:30(UTC) to 14:00(YGN)
    func convertFromUTCTimestamp() -> String? {
        let strArr: [String] = self.components(separatedBy: ":")
        guard strArr.count > 1 else {
            return nil
        }
        
        let int0 = Int(strArr[0])
        let int1 = Int(strArr[1])
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        
        let today = Date()
        let com = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: today)
        
        var newcom = DateComponents()
        newcom.year = com.year
        newcom.month = com.month
        newcom.day = com.day
        newcom.hour = int0
        newcom.minute = int1
        let newcomdate = calendar.date(from: newcom)!
        
        let finalf = DateFormatter()
        finalf.dateFormat = "HH:mm"
        return finalf.string(from: newcomdate)
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func toDate(format: DateFormat, useBaseLang: Bool = false) -> Date? {
        
        let dateFormatter = DateFormatter()
        
        if useBaseLang {
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        }
        
        dateFormatter.dateFormat = format.rawValue
        
        return dateFormatter.date(from: self)
    }
    
    func removeWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    func removeFirst() -> String? {
        return self.substring(from: 1, to: self.count)
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: self) {
            return true
        }
        return false
    }
    
    func isValidTaxiNumber() -> Bool {
        
        // TST0728L
        // TST9993C
        // TST8888A
        
        let taxiNumberRegEx = "([A-Z]{2,3})([0-9]{1,4})([A-Z]{1})"
        let taxiNumberTest = NSPredicate(format: "SELF MATCHES %@", taxiNumberRegEx)
        if taxiNumberTest.evaluate(with: self) {
            return true
        }
        return false
    }
    
    
    var fullSgPhone: String {
        
        let groupingSeparator = " " // determined based on user input, as per the question

        let formatter = NumberFormatter()
        formatter.positiveFormat = "####,####"
        formatter.groupingSeparator = groupingSeparator

        if let string = formatter.string(from: NSNumber.init(value: Int(self) ?? 0)) {
            return "+65 \(string)"
        }
        
        return ""
    }
    
    func isValidMobileNumber() -> Bool {
        
        guard self != "" else {
            return false
        }
        
        let mobileTest = NSPredicate(format:"SELF MATCHES %@", "^[89]\\d{7}$")
        return mobileTest.evaluate(with: self)
        
    }
    
    func isImageURL() -> Bool {
        let imageFormats = ["jpg", "png", "gif", "jpeg"]
        
        if URL(string: self) != nil {
            let extensi = (self as NSString).pathExtension
            return imageFormats.contains(extensi)
        }
        return false
    }
    
    /**
     Getting Last 4
     */
    func last4() -> String {
        let maxCount = self.count
        if maxCount >= 4 {
            return self.substring(from: maxCount - 4, to: maxCount)
        } else {
            return ""
        }
    }
    
    /// if the string is "" return nil, otherwise actual value is returned
    var valueOrNil: String? {
        return self == "" ? nil : self
    }

    
    /*func md5() -> String {
        let messageData = self.data(using: .utf8)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        
        return digestData.map { String(format: "%02hhx", $0) }.joined()
    } */
    
    func toDate(dateFormat: String, setLocalTimeZone: Bool = false) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale(identifier: "en_US_POSIX")
        if !setLocalTimeZone { formatter.timeZone = TimeZone(secondsFromGMT: 0) }
        return formatter.date(from: self)
    }
    
    func add(character: String, byOffset offset: Int) -> String {
        
        var newString = ""
        
        for (index, char) in self.enumerated() {
            
            if index % offset == 0 && index != 0 {
                newString += "\(character)"
            }
            newString += "\(char)"
        }
        return newString
    }
    
    func removeAllSpaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    var isNumberWithDecimal: Bool {  return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil }
    
    var isNumber: Bool { return Int(self) != nil }
    
    var isSingleEmoji: Bool { count == 1 && containsEmoji }

    var containsEmoji: Bool { contains { $0.isEmoji } }

    var containsOnlyEmoji: Bool { !isEmpty && !contains { !$0.isEmoji } }

    var emojiString: String { emojis.map { String($0) }.reduce("", +) }

    var emojis: [Character] { filter { $0.isEmoji } }

    var emojiScalars: [UnicodeScalar] { filter { $0.isEmoji }.flatMap { $0.unicodeScalars } }
    
    func customStringFormatting(delimiter: String) -> String {
        return chunk(n: 4)
            .map{ String($0) }.joined(separator: " ")
    }
    
    func chunkFormatted(withChunkSize chunkSize: Int = 4, withSeparator separator: Character = " ") -> (String,String) {
        
        let original = self
        var strings = original.map { String($0) }
        if count < 15 {
            strings =  strings.map { !($0 == " ") ? "*" : $0}
        }
        let newStr = filter { $0 != separator }.chunk(n: chunkSize)
            .map{ String($0) }.joined(separator: String(separator))
        return (newStr,original)
    }
    
    func mmNumbers() -> String {
        var mm = ""
        self.forEach { (char) in
            switch char {
            case "0": mm.append("၀")
            case "1": mm.append("၁")
            case "2": mm.append("၂")
            case "3": mm.append("၃")
            case "4": mm.append("၄")
            case "5": mm.append("၅")
            case "6": mm.append("၆")
            case "7": mm.append("၇")
            case "8": mm.append("၈")
            case "9": mm.append("၉")
            default: mm.append(char)
            }
        }
        return mm.isEmpty ? self : mm
    }
    
    func mmMonth() -> String {
        switch self.lowercased() {
        case "january": return "ဇန်နဝါရီ"
        case "february": return "ဖေဖော်ဝါရီ"
        case "march": return "မတ်"
        case "april": return "ဧပြီ"
        case "may": return "မေ"
        case "june": return "ဇွန်"
        case "july": return "ဇူလိုင်"
        case "august": return "သြဂုတ်လ"
        case "september": return "စက်တင်ဘာ"
        case "october": return "အောက်တိုဘာ"
        case "november": return "နိုဝင်ဘာ"
        case "december": return "ဒီဇင်ဘာ"
        default: return self
        }
    }
}
