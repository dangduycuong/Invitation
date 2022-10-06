//
//  TitleView.swift
//  Invitation
//
//  Created by cuongdd on 05/10/2022.
//  Copyright © 2022 Dang Duy Cuong. All rights reserved.
//

import UIKit

class TitleView: UIView {
    
    @IBOutlet weak var wifeTextField: UITextField!
    @IBOutlet weak var husbandTextField: UITextField!
    @IBOutlet weak var widthContainerView: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        wifeTextField.delegate = self
        husbandTextField.delegate = self
        setupUI()
    }
    
    private func setupUI() {
        widthContainerView.constant = UIScreen.main.bounds.width - 44 * 2 - 16 * 2
        let style = NSMutableParagraphStyle()
        var attributes: [NSAttributedString.Key: Any] = [
            .font: R.font.playfairDisplayItalic(size: 17) as Any,
            .foregroundColor: UIColor.lightGray,
            .paragraphStyle: style,
        ]
        
        husbandTextField.attributedPlaceholder = NSAttributedString(string: "Chồng", attributes: attributes)
        style.alignment = .center
        attributes[.paragraphStyle] = style
        wifeTextField.attributedPlaceholder = NSAttributedString(string: "Vợ", attributes: attributes)
    }
    
    func fillData() {
        if let wife = UserDefaults.standard.string(forKey: UserDefaultKey.wife.rawValue) {
            wifeTextField.text = wife
        }
        if let husband = UserDefaults.standard.string(forKey: UserDefaultKey.husband.rawValue) {
            husbandTextField.text = husband
        }
    }
}

extension TitleView: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        UserDefaults.standard.set(wifeTextField.text, forKey: UserDefaultKey.wife.rawValue)
        UserDefaults.standard.set(husbandTextField.text, forKey: UserDefaultKey.husband.rawValue)
    }
}
