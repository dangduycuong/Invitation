//
//  AlertService.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 11/26/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit

enum AlertType {
    case notice
    case warning
    case error
    
    static var all = [notice,warning,error]
    var text: String {
        get {
            switch self {
            case .notice:
                return "Thông Báo"
            case .warning:
                return "Cảnh Báo"
            case .error:
                return "Lỗi"
            }
        }
    }
}

class AlertService {
    let storyboard = UIStoryboard.init(name: "BaseAlert", bundle: nil)
    
    func showAlertWithConfirm(type: AlertType, message: String, cancel: @escaping () -> Void, ok: @escaping () -> Void) -> ShowAlertWithConfirm {
        let vc = storyboard.instantiateViewController(withIdentifier: "ShowAlertWithConfirm") as! ShowAlertWithConfirm
//        let vc = storyboard.instantiateViewController(identifier: "ShowAlertWithConfirm") as! ShowAlertWithConfirm
        vc.alertType = type
        vc.message = message
        vc.cancelClosure = cancel
        vc.okClosure = ok
        return vc
    }
    
//    func reLogin(type: AlertType, message: String, action: @escaping () -> Void) -> ReLoginVC {
//        let vc = Storyboard.Main.reLoginVC()
//        vc.actionReLogin = action
//        return vc
//    }
    
    func showAlertViewController(type: AlertType, message: String, close: @escaping () -> Void) -> ShowAlertViewController {
            let vc = storyboard.instantiateViewController(withIdentifier: "ShowAlertViewController") as! ShowAlertViewController
            vc.type = type
            vc.message = message
            vc.closeAction = close
            return vc
        }
    
}
