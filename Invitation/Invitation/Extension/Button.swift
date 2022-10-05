//
//  Button.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/18/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit

extension UIButton {
    @objc override func setDefaultButton() {
        super.setDefaultButton()
        self.clipsToBounds = true
        self.setTitleColor(UIColor.white, for: .normal)
        self.contentEdgeInsets = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
        self.titleLabel?.font = R.font.playfairDisplayRegular(size: 17)
    }
    
    @objc override func setDefaultButtonWithoutCorner() {
        super.setDefaultButtonWithoutCorner()
        self.clipsToBounds = true
        self.setTitleColor(UIColor.white, for: .normal)
        
    }
}
