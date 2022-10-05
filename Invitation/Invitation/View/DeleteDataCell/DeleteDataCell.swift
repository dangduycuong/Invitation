//
//  DeleteDataCell.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/17/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit

class DeleteDataCell: BaseTableViewCell {
    
    @IBOutlet weak var relationTextView: UITextView!
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var diaChiTextView: UITextView!
    @IBOutlet weak var addressTextView: UITextView!
    
    @IBOutlet weak var ageTextView: UITextView!
    @IBOutlet weak var tienDiTextView: UITextView!
    @IBOutlet weak var giftMoneyTextView: UITextView!
    
    @IBOutlet weak var tienNhanTextView: UITextView!
    
    @IBOutlet weak var receivedMoneyTextView: UITextView!
    @IBOutlet weak var trangThaiMoiTextView: UITextView!
    @IBOutlet weak var statusSwitch: UISwitch!
    @IBOutlet weak var ghiChuTextView: UITextView!
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBOutlet weak var selectedView: UIView!
    
    var infoKM = ThongTinKhachMoiModel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillData() {
        relationTextView.text = infoKM.quan_he
        nameTextView.text = infoKM.name
        ageTextView.text = infoKM.age
        addressTextView.text = infoKM.address
        giftMoneyTextView.text = infoKM.giftMoney?.toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
        receivedMoneyTextView.text = infoKM.moneyReceived?.toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
        noteTextView.text = infoKM.note
        selectedView.isHidden = !isSelected
        statusSwitch.isOn = infoKM.status
    }
    
}
