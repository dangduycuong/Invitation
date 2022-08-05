//
//  ChangeInfomationUserView.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/16/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit

struct DataUser {
    var username: String?
    var old_password: String?
    var new_password: String?
    var repeat_password: String?
    var back: Bool?
}

class ChangeInfomationUserView: UIView, UITextFieldDelegate {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    @IBOutlet weak var titleNhapLaiMatKhauLabel: UILabel!
    
    @IBOutlet weak var editUsernameButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var closureUpdateUser: ((DataUser) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        usernameTextField.delegate = self
        oldPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        repeatPasswordTextField.delegate = self
        fillData()
        setupMessageContentText(string: "Nhập lại mật khẩu")
        setDisplay()
    }
    
    func fillData() {
        if let username = UserDefaults.standard.string(forKey: UserDefaultKey.usernameAuthentication.rawValue) {
            usernameTextField.text = username
        }
    }
    
    func setDisplay() {
        oldPasswordTextField.isSecureTextEntry = true
        newPasswordTextField.isSecureTextEntry = true
        repeatPasswordTextField.isSecureTextEntry = true
        
        cancelButton.setDefaultButton()
        saveButton.setDefaultButton()
    }
    
    func setupMessageContentText(string: String) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 6
        style.alignment = .left
        
        let attributes : [NSAttributedString.Key : Any] =
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0),
             NSAttributedString.Key.foregroundColor : UIColor.black,
             NSAttributedString.Key.paragraphStyle : style]
        
        let attributeString = NSAttributedString(string: string, attributes: attributes)
        self.titleNhapLaiMatKhauLabel.attributedText = attributeString
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case usernameTextField:
            editUsernameButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10);
            editUsernameButton.setImage(#imageLiteral(resourceName: "icons8-delete_sign_filled"), for: .normal)
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTextField:
            oldPasswordTextField.becomeFirstResponder()
        case oldPasswordTextField:
            newPasswordTextField.becomeFirstResponder()
        case newPasswordTextField:
            repeatPasswordTextField.becomeFirstResponder()
        case repeatPasswordTextField:
            repeatPasswordTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
        closeKeyboard()
    }
    
    func closeKeyboard() {
        usernameTextField.resignFirstResponder()
        oldPasswordTextField.resignFirstResponder()
        newPasswordTextField.resignFirstResponder()
        repeatPasswordTextField.resignFirstResponder()
    }
    
    @IBAction func tapCancelEdit(_ sender: Any) {
        editUsernameButton.setImage(#imageLiteral(resourceName: "icons8-edit_filled"), for: .normal)
        fillData()
        usernameTextField.resignFirstResponder()
    }
    
    @IBAction func tapCancel(_ sender: UIButton!) {
        fillData()
        oldPasswordTextField.text = ""
        newPasswordTextField.text = ""
        repeatPasswordTextField.text = ""
        
        closeKeyboard()
    }
    
    @IBAction func tapUpdate(_ sender: UIButton!) {
        var user = DataUser()
        user.username = usernameTextField.text
        user.old_password = oldPasswordTextField.text
        user.new_password = newPasswordTextField.text
        user.repeat_password = repeatPasswordTextField.text
        closureUpdateUser?(user)
    }
    
    @IBAction func tapShowOldPassword(_ sender: UIButton!) {
        let temp = oldPasswordTextField.isSecureTextEntry
        let imageNamed = temp ? "icons8-visible-1" : "icons8-hide-1"
        sender.setImage(UIImage(named: imageNamed), for: .normal)
        oldPasswordTextField.isSecureTextEntry = !temp
    }
    
    @IBAction func tapShowNewPassword(_ sender: UIButton!) {
        let temp = newPasswordTextField.isSecureTextEntry
        let imageNamed = temp ? "icons8-visible-1" : "icons8-hide-1"
        sender.setImage(UIImage(named: imageNamed), for: .normal)
        newPasswordTextField.isSecureTextEntry = !temp
    }
    
    @IBAction func tapShowRepeatPassword(_ sender: UIButton!) {
        let temp = repeatPasswordTextField.isSecureTextEntry
        let imageNamed = temp ? "icons8-visible-1" : "icons8-hide-1"
        sender.setImage(UIImage(named: imageNamed), for: .normal)
        repeatPasswordTextField.isSecureTextEntry = !temp
    }
    
}
