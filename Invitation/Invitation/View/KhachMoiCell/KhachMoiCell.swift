//
//  KhachMoiCell.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 11/26/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit

class KhachMoiCell: BaseTableViewCell, UITextViewDelegate {
    
//    @IBOutlet weak var titleNameTextView: UITextView!
    @IBOutlet weak var controlConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleAgeTextView: UITextView!
    
    @IBOutlet weak var titleAddressTV: UITextView!
    
    @IBOutlet weak var titlePhoneTV: UITextView!
    
    @IBOutlet weak var titleStatusTV: UITextView!
    
    @IBOutlet weak var tenTextView: UITextView!
    
    @IBOutlet weak var tuoiTextView: UITextView!
    
    @IBOutlet weak var diaChiTextView: UITextView!
    
    @IBOutlet weak var quanHeTextView: UITextView!
    
    @IBOutlet weak var phoneTextView: UITextView!
    
    @IBOutlet weak var statusSwitch: UISwitch!
    
    @IBOutlet weak var checkImageView: UIImageView!
    
    fileprivate let application = UIApplication.shared
    var infoKhachMoi = ThongTinKhachMoiModel()
    var isDelete = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        phoneTextView.delegate = self
        setFont()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func checkSelect(index: IndexPath, isDelete: Bool) {
        if isDelete {
            controlConstraint.constant = 8
            checkImageView.isHidden = false
//            if let isDelete = listODF[index.row].isDelete {
//                if isDelete {
//                    checkImageView.image = #imageLiteral(resourceName: "icons8-checked_checkbox")
//                } else {
//                    checkImageView.image = #imageLiteral(resourceName: "icons8-unchecked_checkbox")
//                }
//            }
            checkImageView.image = infoKhachMoi.isDelete ? UIImage(named: "icons8-checked_checkbox") : UIImage(named: "icons8-unchecked_checkbox")
        } else {
            controlConstraint.constant = -28
        }
        
    }
    
    func setFont() {
        quanHeTextView.setDefaultTitleField()
        titleAgeTextView.setDefaultTitleField()
        titleAddressTV.setDefaultTitleField()
        titlePhoneTV.setDefaultTitleField()
        titleStatusTV.setDefaultTitleField()
        
        statusSwitch.set(width: 45, height: 25)
    }
    
    func fillData() {
        tenTextView.text = infoKhachMoi.name
        tuoiTextView.text = infoKhachMoi.age
        diaChiTextView.text = infoKhachMoi.address
        quanHeTextView.text = infoKhachMoi.quan_he
        
        //fff
        statusSwitch.isOn = infoKhachMoi.status
        if let phone = infoKhachMoi.phone {
            phoneTextView.text = phone
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == phoneTextView {
            phoneTextView.resignFirstResponder()
            calling()
        }
    }
    
    func calling() {
        let urlSchema = "tel:"
        let numberToCall = infoKhachMoi.phone
        if let numberToCallURL = URL(string: "\(urlSchema)\(String(describing: numberToCall))") {
            if UIApplication.shared.canOpenURL(numberToCallURL) {
                application.open(numberToCallURL, options: [:], completionHandler: nil)
            } else {
                // show alert
            }
        }
    }
    
}
