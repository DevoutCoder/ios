//
//  String.swift
//  OneKey
//
//  Created by xuxiwen on 2021/3/16.
//  Copyright © 2021 Onekey. All rights reserved.
//

import Foundation

extension String {

    var coinImage: UIImage? {
        guard !self.isEmpty else { return nil }
        return UIImage(named: "token_" + self.lowercased())
    }

    func divEthereumUnit(type: EthereumUnit = .ether, scale: Int16 = 6) -> NSDecimalNumber {
        guard !self.isEmpty else { return NSDecimalNumber(value: 0) }
        guard self != "0" else { return NSDecimalNumber(value: 0) }
        let value = NSDecimalNumber(string: self)
        let ratio = NSDecimalNumber(string: String(type.rawValue))
        let behavior = NSDecimalNumberHandler(
            roundingMode: .down,
            scale: scale,
            raiseOnExactness: false,
            raiseOnOverflow: false,
            raiseOnUnderflow: false,
            raiseOnDivideByZero: true
        )
        let result = value.dividing(by: ratio, withBehavior: behavior)
        return result
    }

    func multiplyingEthereumUnit(type: EthereumUnit = .ether, scale: Int16 = 6) -> NSDecimalNumber {
        guard !self.isEmpty else { return NSDecimalNumber(value: 0) }
        guard self != "0" else { return NSDecimalNumber(value: 0) }
        let value = NSDecimalNumber(string: self)
        let ratio = NSDecimalNumber(string: String(type.rawValue))
        let behavior = NSDecimalNumberHandler(
            roundingMode: .down,
            scale: scale,
            raiseOnExactness: false,
            raiseOnOverflow: false,
            raiseOnUnderflow: false,
            raiseOnDivideByZero: true
        )
        let result = value.multiplying(by: ratio, withBehavior: behavior)
        return result
    }

   var localized: String {
       guard !isEmpty else { return "" }
       return (self as NSString).localized()
   }

   var has0xPrefix: Bool {
       return hasPrefix("0x")
   }

    var addPreHttps: String {
        if isEmpty {
            return ""
        }
        if hasPrefix("https") {
            return self
        } else if hasPrefix("//") {
            return "https:" + self
        } else {
            return "https://" + self
        }
    }

   var drop0x: String {
       if count > 2 && substring(with: 0..<2) == "0x" {
           return String(dropFirst(2))
       }
       return self
   }

   var add0x: String {
       if hasPrefix("0x") {
           return self
       } else {
           return "0x" + self
       }
   }

   var hextToDec: Int {
       return 0
   }

    var hexToDecimal: Int {
        guard !isEmpty else { return 0 }
        return Int(self.drop0x, radix: 16) ?? 0
    }

    var keccak256: String {
        return (self as NSString).keccak256()
    }

    var toInt: Int {
        return Int(self) ?? 0
    }

    var toURL: URL? {
        return URL.init(string: self)
    }

    var toUIImage: UIImage? {
        if isEmpty {
            return nil
        }
        return UIImage(named: self)
    }

    var addressName: String {
        if count <= 4 {
            return self
        }
        return substring(from: count - 4).uppercased()
    }

     func isValidURL() -> Bool {
        if let url = NSURL(string: self) {
            return UIApplication.shared.canOpenURL(url as URL)
        }
        return false
    }

    func chainNameToTokenName() -> String {
        switch self.uppercased() {
        case "BSC":
            return "BNB"
        case "HECO":
            return "HT"
        default:
            return self.uppercased()
        }
    }

    func favicon() -> String {
        guard let url = self.addPreHttps.toURL else { return  "" }
        guard let host = url.host else { return "" }
        return "https://api.faviconkit.com/\(host)/144"
    }

    var isNotEmpty: Bool {
        return !isEmpty
    }

    var isNaN: Bool {
        return  self == "NaN"
    }

    var hexStringToString: String? {
        return Data(hexString: self)?.string(encoding: .utf8)
    }

}

extension String {
    func index(from: Int) -> Index {
        return index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }

    func nextLetterInAlphabet(for index: Int) -> String? {
        guard let uniCode = UnicodeScalar(self) else {
            return nil
        }
        switch uniCode {
        case "A"..<"Z":
            return String(UnicodeScalar(uniCode.value.advanced(by: index))!)
        default:
            return nil
        }
    }
}
