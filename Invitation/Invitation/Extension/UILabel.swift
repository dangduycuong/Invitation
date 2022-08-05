//
//  UILabel.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/10/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit
extension UILabel {
    
    func setDefaultFont(){
        self.font = Constant.font.robotoRegular(ofSize: 15)
    }
    
    func setDeFaultButtonFont() {
        self.font = Constant.font.robotoMedium(ofSize: 16)
    }
    
    func setDefaultTitleField(){
        self.font = Constant.font.robotoRegular(ofSize: 14)
        self.textColor = UIColor.darkGray
    }
    
    func setTitleFont(){
        self.font = Constant.font.robotoBold(ofSize: 17)
    }
    
    func setFontSize(size: CGFloat){
        self.font = Constant.font.robotoRegular(ofSize: size)
    }
    
    func addNoteString(string: String, font: UIFont? = Constant.font.robotoRegular(ofSize: 15), color: UIColor? = UIColor.red) {
        self.text = string + (self.text ?? "")
        let attribute = NSMutableAttributedString(string: self.text!, attributes: [NSAttributedString.Key.font:font!])
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:0,length:1))
        self.attributedText = attribute
    }
    
    func componentWithString(_ string: String, font: UIFont, color: UIColor) {
        if let currentString = self.text {
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: currentString)
            attributedString.componentWithString(string, font: font, color: color)
            self.attributedText = attributedString
        }
    }
    
    func underline() {
        if let textString = self.text {
            let attributedString = NSAttributedString(string: textString, attributes:
                [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
            attributedText = attributedString
        }
    }
    
    
}
