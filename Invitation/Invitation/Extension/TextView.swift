//
//  TextView.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/3/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    
    func setDefaultFont() {
        self.font = Constant.font.robotoRegular(ofSize: 16)
    }
    
    func setDeFaultButtonFont() {
        self.font = Constant.font.robotoMedium(ofSize: 16)
    }
    
    func setDefaultTitleField(){
        self.font = Constant.font.robotoRegular(ofSize: 14)
        self.textColor = UIColor.darkGray
    }
}
