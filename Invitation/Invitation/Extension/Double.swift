//
//  Double.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/9/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit

extension Double {
    func displayDecimal(groupingSeparator: String, decimalSeparator: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 20
        formatter.decimalSeparator = decimalSeparator
        formatter.groupingSeparator = groupingSeparator
        
        if let scientificFormatted = formatter.string(for: self) {
            return scientificFormatted
        }
        return "0"
        
    }
    
    func convertToShortString() -> String
    {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.positiveFormat = "0.0###E0"
        formatter.exponentSymbol = "E"
        formatter.decimalSeparator = "."
        if let scientificFormatted = formatter.string(for: self) {
            return scientificFormatted
        }
        return "0"
    }
    
    func toString() -> String {
        let string = String(format: "%.3f", self)
        return string
    }
    func toFloat() -> Float {
        return Float(self)
    }
    //cuongdd - add for nims cable line
    func toShortString() -> String {
        let string = String(format: "%.1f", self)
        return string
    }
    
}
