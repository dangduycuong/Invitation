//
//  GetPasswordView.swift
//  Invitation
//
//  Created by Boss on 12/18/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit
enum ActionGetPassword {
    case cancel
    case faceID
    case fingerprint
}

class GetPasswordView: UIView {
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var faceIDView: UIView!
    @IBOutlet weak var touchIDView: UIView!
    
    
    var closureFromGetPassword: ((ActionGetPassword) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setShadowView(view: faceIDView)
        setShadowView(view: touchIDView)
        
        setShadowButton(button: closeButton)
    }
    
    func checkDisPlay(isFaceID: Bool) {
        if isFaceID {
            faceIDView.isHidden = false
            touchIDView.isHidden = true
        } else {
            faceIDView.isHidden = true
            touchIDView.isHidden = false
        }
    }
    func setShadowView(view: UIView) {
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
    }
    
    func setShadowButton(button: UIButton) {
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowOpacity = 0.8
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 10
    }
    // MARK: Action
    @IBAction func tapDissmiss(_ sender: UIButton) {
        closureFromGetPassword?(.cancel)
    }
    @IBAction func tapgetPasswordFaceID(_ sender: Any) {
        closureFromGetPassword?(.faceID)
    }
    @IBAction func tapGetPasswordFingerprint(_ sender: Any) {
        closureFromGetPassword?(.fingerprint)
    }
}
