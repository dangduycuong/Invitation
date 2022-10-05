//
//  Identifier.swift
//  Invitation
//
//  Created by cuongdd on 05/10/2022.
//  Copyright © 2022 Dang Duy Cuong. All rights reserved.
//

import UIKit

//
// MARK: - Identifier
// Easily to get ViewID and XIB file
protocol Identifier {
    
    /// ID view
    static var identifierView: String {get}
    
    /// XIB - init XIB from identifierView
    static func xib() -> UINib?
}
