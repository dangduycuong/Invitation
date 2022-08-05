//
//  ShowAlertViewController.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/23/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit

class ShowAlertViewController: UIViewController {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var noticeTextView: UITextView!
    
    
    var type = AlertType.notice
    var closeAction: (() -> Void)?
    var message: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewAlert()
        setAlert()
        setShadowView()
    }
    
    func setViewAlert() {
        var background = #colorLiteral(red: 0.01176470588, green: 0.6078431373, blue: 0.8980392157, alpha: 1)
        var textColor = #colorLiteral(red: 0.01176470588, green: 0.6078431373, blue: 0.8980392157, alpha: 1)
        var resourceName = "ic_notice_blue"
        switch type {
        case .notice:
            background = #colorLiteral(red: 0.7019607843, green: 0.8980392157, blue: 0.9882352941, alpha: 1)
            resourceName = "ic_notice_blue"
            textColor = #colorLiteral(red: 0.01176470588, green: 0.6078431373, blue: 0.8980392157, alpha: 1)
            closeButton.setTitleColor(#colorLiteral(red: 0.01176470588, green: 0.6078431373, blue: 0.8980392157, alpha: 1), for: .normal)
        case .warning:
            background = #colorLiteral(red: 1, green: 0.9764705882, blue: 0.768627451, alpha: 1)
            resourceName = "ic_notice_orange"
            textColor = #colorLiteral(red: 0.01176470588, green: 0.6078431373, blue: 0.8980392157, alpha: 1)
            closeButton.setTitleColor(#colorLiteral(red: 0.9843137255, green: 0.7529411765, blue: 0.1764705882, alpha: 1), for: .normal)
        case .error:
            background = #colorLiteral(red: 1, green: 0.8039215686, blue: 0.8235294118, alpha: 1)
            resourceName = "ic_notice_red"
            textColor = #colorLiteral(red: 0.937254902, green: 0.3254901961, blue: 0.3137254902, alpha: 1)
            closeButton.setTitleColor(#colorLiteral(red: 0.937254902, green: 0.3254901961, blue: 0.3137254902, alpha: 1), for: .normal)
        }
        iconImageView.image = UIImage(named: resourceName)
        titleView.backgroundColor = background
        noticeTextView.textColor = textColor
    }
    
    func setAlert() {
//        titleLabel.text = type.text
        noticeTextView.text = type.text
        setupMessageContentText(string: message)
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
        self.messageTextView.attributedText = attributeString
    }

    @IBAction func tapClose(_ sender: UIButton) {
        dismiss(animated: false, completion: closeAction)
    }
    
}
