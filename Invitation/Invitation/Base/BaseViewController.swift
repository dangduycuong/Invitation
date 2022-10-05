//
//  BaseViewController.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 11/26/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var spinner = UIActivityIndicatorView()
    let alertService = AlertService()
    lazy var isLoading: Bool = false
    private var enableHideKeyBoardWhenTouchInScreen: Bool = true
    var isEnableHideKeyBoardWhenTouchInScreen: Bool {
        get {
            return self.enableHideKeyBoardWhenTouchInScreen ? true : false
        }
        
        set {
            self.enableHideKeyBoardWhenTouchInScreen = newValue
            if self.enableHideKeyBoardWhenTouchInScreen {
                let touchOnScreen = UITapGestureRecognizer(target: self, action: #selector(self.touchOnScreen))
                touchOnScreen.delegate = self
                touchOnScreen.cancelsTouchesInView = false
                view.addGestureRecognizer(touchOnScreen)
            }
        }
    }
    
    @objc func touchOnScreen() {
        view.endEditing(true)
    }
    
    func setSpinner() {
        view.alpha = 0.95
        spinner.style = .large
        spinner.color = #colorLiteral(red: 0, green: 0, blue: 0.5019607843, alpha: 1)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func showLoading() {
        setSpinner()
        spinner.startAnimating()
        view.isUserInteractionEnabled = false
    }
    
    func hideLoading() {
        view.alpha = 1
        spinner.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    
    func showAlertWithConfirm(type: AlertType, message: String, cancel: @escaping () -> Void, ok: @escaping () -> Void) -> Void {
        let vc = alertService.showAlertWithConfirm(type: type, message: message, cancel: cancel, ok: ok)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: false, completion: nil)
    }
    
    func showAlertViewController(type: AlertType, message: String, close: @escaping () -> Void) -> Void {
        let vc = alertService.showAlertViewController(type: type, message: message, close: close)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: false, completion: nil)
    }
    
    func setShadowView(view: UIView) {
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
    }
    
    func setShadowButton(button: UIButton, cornerRadius: CGFloat) {
        button.layer.cornerRadius = cornerRadius
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 10
    }
    
    func setPlaceholder(textView: UITextView, label: UILabel, text: String) {
        label.text = text
        label.font = R.font.playfairDisplayItalic(size: 17)
        label.sizeToFit()
        textView.addSubview(label)
        label.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
        label.textColor = UIColor.lightGray
        label.isHidden = !textView.text.isEmpty
    }
    //login lai
//    func reLogin(resultcode: String, action: @escaping() -> ()) {
//        guard resultcode == "MS-0004" else {
//            return
//        }
//        self.showAlert(type: .notice, message: "Phiên đăng nhập của bạn đã hết hạn.\nVui lòng đăng nhập", close: {
//            let vc = Storyboard.Main.reLoginVC()
//            vc.modalPresentationStyle = .overFullScreen
//            vc.modalTransitionStyle = .crossDissolve
//            vc.actionReLogin = action
//            self.present(vc, animated: true, completion: nil)
//        })
//    }
    func backVC(controller: UIViewController){
        DispatchQueue.main.async {
            let vc = controller
            let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            
            keyWindow?.rootViewController = vc
            keyWindow?.endEditing(true) //co cung thay chay ma bo di cung chay
        }
    }
}


