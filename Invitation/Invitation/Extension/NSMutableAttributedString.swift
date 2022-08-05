//
//  NSMutableAttributedString.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/10/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    
    func componentWithString(_ string: String, font: UIFont, color: UIColor) {
        let range = self.mutableString.range(of: string, options: .caseInsensitive)
        if range.location != NSNotFound {
            self.addAttributes([NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color], range: range)
        }
    }
}
