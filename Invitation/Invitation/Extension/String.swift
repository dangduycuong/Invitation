//
//  String.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/2/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit

extension String {
    //chuyen doi string sang timeInterval. Comment lai vi khong dung den.
//    func convertToTimeInterval() -> TimeInterval {
//        guard self != "" else {
//            return 0
//        }
//
//        var interval: Double = 0
//
//        let parts = self.components(separatedBy: ":")
//        for (index, part) in parts.reversed().enumerated() {
//            interval += (Double(part) ?? 0) * pow(Double(60), Double(index))
//        }
//
//        return interval
//    }

    static func random(length: Int = 10) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""

        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
    
    //Converts String to Int
    public func toInt() -> Int? {
        if let num = NumberFormatter().number(from: self) {
            return num.intValue
        } else {
            return nil
        }
    }

    //Converts String to Double
    public func toDouble() -> Double? {
        if let num = NumberFormatter().number(from: self) {
            return num.doubleValue
        } else {
            return nil
        }
    }

    /// EZSE: Converts String to Float
    public func toFloat() -> Float? {
        if let num = NumberFormatter().number(from: self) {
            return num.floatValue
        } else {
            return nil
        }
    }

    //Converts String to Bool
    public func toBool() -> Bool? {
        return (self as NSString).boolValue
    }
}
