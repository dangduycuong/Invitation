//
//  GetPasswordVC.swift
//  Invitation
//
//  Created by Boss on 12/18/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit
import LocalAuthentication

enum DisPlayPasswordView {
    case getPassword
    case showPassword
}

class GetPasswordVC: BaseViewController {
    @IBOutlet weak var contentView: UIView!
    
    let mycontext:LAContext = LAContext()
    var showDetailInfo: DisPlayPasswordView = .getPassword {
        didSet {
            getPasswordView.isHidden = true
            showPasswordView.isHidden = true
            switch showDetailInfo {
            case .getPassword:
                getPasswordView.isHidden = false
            case .showPassword:
                showPasswordView.isHidden = false
            }
        }
    }
    
    lazy var getPasswordView: UIView = {
        let getPasswordView: GetPasswordView = GetPasswordView.loadFromNib()
        //        optionCableView.delegate = self //use clocure
        getPasswordView.frame = contentView.bounds
        contentView.addSubview(getPasswordView)
        return getPasswordView
    }()
    
    lazy var showPasswordView: UIView = {
        let showPasswordView: ShowPasswordView = ShowPasswordView.loadFromNib()
        //        optionCableView.delegate = self //use clocure
        showPasswordView.frame = contentView.bounds
        contentView.addSubview(showPasswordView)
        return showPasswordView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDetailInfo = .getPassword
        if let getPasswordView = getPasswordView as? GetPasswordView {
            getPasswordView.closureFromGetPassword = { [weak self] data in
                self?.implementClosurePasswordView(action: data)
            }
            getPasswordView.checkDisPlay(isFaceID: checkFaceID())
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func implementClosurePasswordView(action: ActionGetPassword) {
        switch action {
        case .cancel:
            dismiss(animated: true, completion: nil)
        case .faceID:
            authenticateUser()
        case .fingerprint:
            authenticateUser()
        }
    }
    
    func authenticateUser() {
        let authenticationContext = LAContext()
        var error: NSError?
        //        let reasonString = "Touch the Touch ID sensor to unlock."
        let reasonString = "Chạm vào cảm biến để mở khoá"
        
        // Check if the device can evaluate the policy.
        if authenticationContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &error) {
            
            authenticationContext.evaluatePolicy( .deviceOwnerAuthentication, localizedReason: reasonString, reply: { (success, evalPolicyError) in
                
                if success {
                    print("success")
                    DispatchQueue.main.async {
                        self.showDetailInfo = .showPassword
                        self.setupWhenChangeUser()
                    }
                } else {
                    // Handle evaluation failure or cancel
                }
            })
            
        } else {
            print("passcode not set")
        }
    }
    
    func updateUser(_ data: DataUser) -> Bool {
        if data.username == "" {
            showAlertViewController(type: .error, message: "Chưa nhập tên đăng nhập. Điền tên đăng nhập trước", close: {
                
            })
            return false
        }
        
        if data.new_password == "" {
            showAlertViewController(type: .error, message: "Chưa nhập mật khẩu mới. Nhập mật khẩu mới trước", close: {
                
            })
            return false
        }
        if data.repeat_password != data.new_password {
            showAlertViewController(type: .error, message: "Nhập lại mật khẩu mới sai", close: {
                
            })
            return false
        }
        return true
    }
    
    func checkFaceID() -> Bool {
        if mycontext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            if mycontext.biometryType == .faceID {
                return true
            } else if mycontext.biometryType == .touchID {
                return false
            }
        }
        return false
    }
    
    func setupWhenChangeUser() {
        if let showView = self.showPasswordView as? ShowPasswordView {
            showView.closureUpdateUser = { [weak self] data in
                if let back = data.back {
                    if back {
                        self?.dismiss(animated: true, completion: nil)
                    }
                }
                if let result = self?.updateUser(data) {
                    guard result else { return }
                    UserDefaults.standard.set(data.username, forKey: UserDefaultKey.usernameAuthentication.rawValue)
                    UserDefaults.standard.set(data.new_password, forKey: UserDefaultKey.passwordAuthentication.rawValue)
                    self?.showAlertViewController(type: .notice, message: "Cập nhật thông tin người dùng thành công", close: {
                        self?.showDetailInfo = .showPassword
                        UserDefaults.standard.removeObject(forKey: UserDefaultKey.password.rawValue)
                        self?.dismiss(animated: true, completion: nil)
                    })
                }
            }
        }
    }
    
}
