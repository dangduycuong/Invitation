//
//  Int.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/3/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import Foundation

extension Int {
    
    func toBool() -> Bool {
        switch self {
        case 0:
            return false
        case 1:
            return true
        default:
            return false
        }
    }
    
    func toString() -> String {
        return String(self)
    }
    
    func isZero() -> Bool {
        guard self == 0 else {
            return false
        }
        
        return true
    }
}

