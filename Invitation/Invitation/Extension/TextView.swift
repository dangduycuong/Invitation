//
//  TextView.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/3/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit

extension UITextView {
    
    func setDefaultFont() {
        self.font = R.font.playfairDisplayRegular(size: 17)
    }
    
    func setDeFaultButtonFont() {
        self.font = R.font.playfairDisplayRegular(size: 17)
    }
    
    func setDefaultTitleField(){
        self.font = R.font.playfairDisplayBold(size: 17)
        self.textColor = UIColor.darkGray
    }
}
