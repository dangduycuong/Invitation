//
//  ShowAlertWithConfirm.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 11/26/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit

class ShowAlertWithConfirm: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var backgroundButtonView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var alertType = AlertType.notice
    var cancelClosure: (()->())?
    var okClosure: (()->())?
    var message: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewAlert()
        setAlert()
        setShadowView()
    }
    
    func setShadowView() {
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.8
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowRadius = 10
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titleView.roundCorners(corners: [.topLeft, .topRight], radius: 8)
        okButton.roundCorners(corners: [.bottomRight], radius: 8.0)
        cancelButton.roundCorners(corners: [.bottomLeft], radius: 8.0)
        backgroundButtonView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 8.0)
    }
    
    func setAlert() {
        titleLabel.text = alertType.text
        setupMessageContentText(string: message)
    }
    
    func setViewAlert() {
        var textColor = #colorLiteral(red: 0.01176470588, green: 0.6078431373, blue: 0.8980392157, alpha: 1)
        var background = #colorLiteral(red: 0.01176470588, green: 0.6078431373, blue: 0.8980392157, alpha: 1)
        switch alertType {
        case .notice:
//            iconImageView.image = #imageLiteral(resourceName: "ic_notice_blue")
            textColor = #colorLiteral(red: 0.01176470588, green: 0.6078431373, blue: 0.8980392157, alpha: 1)
            background = #colorLiteral(red: 0.7019607843, green: 0.8980392157, blue: 0.9882352941, alpha: 1)
        case .warning:
//            iconImageView.image = #imageLiteral(resourceName: "ic_notice_orange")
            textColor = #colorLiteral(red: 0.9843137255, green: 0.7529411765, blue: 0.1764705882, alpha: 1)
            background = #colorLiteral(red: 1, green: 0.9764705882, blue: 0.768627451, alpha: 1)
        case .error:
//            iconImageView.image = #imageLiteral(resourceName: "ic_notice_red")
            textColor = #colorLiteral(red: 0.937254902, green: 0.3254901961, blue: 0.3137254902, alpha: 1)
            background = #colorLiteral(red: 1, green: 0.8039215686, blue: 0.8235294118, alpha: 1)
        }
        titleLabel.textColor = textColor
        titleView.backgroundColor = background
        cancelButton.setTitleColor(textColor, for: .normal)
        okButton.setTitleColor(textColor, for: .normal)
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
        self.messageLabel.attributedText = attributeString
    }
    
    // MARK: - Action

    @IBAction func tapCancel(_ sender: Any) {
        dismiss(animated: false, completion: cancelClosure)
    }
    
    @IBAction func tapOK(_ sender: Any) {
        dismiss(animated: false, completion: okClosure)
    }
    
}
