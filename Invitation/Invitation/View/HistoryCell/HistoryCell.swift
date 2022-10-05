//
//  HistoryCell.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/9/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit

class HistoryCell: BaseTableViewCell {
    
    @IBOutlet weak var quanHeTextView: UITextView!
    @IBOutlet weak var ageTextView: UITextView!
    @IBOutlet weak var diaChiTextView: UITextView!
    @IBOutlet weak var mungTextView: UITextView!
    @IBOutlet weak var nhanTextView: UITextView!
    @IBOutlet weak var noHeTextView: UITextView!
    
    @IBOutlet weak var tenTextView: UITextView!
    @IBOutlet weak var addressTextView: UITextView!
    
    @IBOutlet weak var giftMoneyTextView: UITextView!
    
    @IBOutlet weak var moneyReceivedTextView: UITextView!
    @IBOutlet weak var oweTextView: UITextView!
    @IBOutlet weak var controlConstraint: NSLayoutConstraint!
    @IBOutlet weak var checkImageView: UIImageView!
    
    var infoKM = ThongTinKhachMoiModel()
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setDisplay() {
        quanHeTextView.setDefaultTitleField()
        diaChiTextView.setDefaultTitleField()
        mungTextView.setDefaultTitleField()
        nhanTextView.setDefaultTitleField()
        noHeTextView.setDefaultTitleField()
        
        oweTextView.setDefaultFont()
    }
    
    func checkSelect(index: IndexPath, isDelete: Bool) {
        if isDelete {
            controlConstraint.constant = 8
            checkImageView.isHidden = false
            checkImageView.image = infoKM.isDelete ? UIImage(named: "icons8-checked_checkbox") : UIImage(named: "icons8-unchecked_checkbox")
        } else {
            controlConstraint.constant = -28
        }
        
    }
    
    func fillData() {
        quanHeTextView.text = infoKM.relation
        tenTextView.text = infoKM.name
        ageTextView.text = infoKM.age
        addressTextView.text = infoKM.address
        giftMoneyTextView.text = infoKM.giftMoney?.toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
        moneyReceivedTextView.text = infoKM.moneyReceived?.toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
        
        if let diMung = infoKM.giftMoney?.toInt(), let nhan = infoKM.moneyReceived?.toInt() {
            let no = diMung - nhan
            oweTextView.text = no.toString().toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
        }
        
    }
    
}
