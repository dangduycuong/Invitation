//
//  ThongTinChiTietKhachMoiCell.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/25/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit
struct EditInfomation {
    var action: EditAction
    var textView: UITextView
    var isShowDropdown: Bool?
}
enum EditAction {
    case relation
    case name
    case year_of_birth
    case address
    case phone
    case monney_received
    case monney_gift
    case note
}

enum ShowOtherView {
    case find_contact
    case tien_nhan
    case tien_di_mung
}

class ThongTinChiTietKhachMoiCell: BaseTableViewCell, UITextViewDelegate {
    @IBOutlet weak var namSinhTextView: UITextView!
    @IBOutlet weak var diaChiTextView: UITextView!
    @IBOutlet weak var sdtTextView: UITextView!
    @IBOutlet weak var tienNhanTextView: UITextView!
    @IBOutlet weak var tienDiTextView: UITextView!
    @IBOutlet weak var noTextView: UITextView!
    @IBOutlet weak var ghiChuTextView: UITextView!
    
    @IBOutlet weak var relationTextView: UITextView!
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var ageTextView: UITextView!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var phoneTextView: UITextView!
    @IBOutlet weak var moneyReceivedTextView: UITextView!
    @IBOutlet weak var giftsMonneyTextView: UITextView!
    @IBOutlet weak var oweTextView: UITextView!
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBOutlet weak var editDiMungButton: UIButton!
    @IBOutlet weak var editTienNhanButton: UIButton!
    
    var infoKM = ThongTinKhachMoiModel()
    var closureCurrentChange: ((EditInfomation) ->())?
    var closureDefault: ((EditInfomation) -> ())?
    var closureChangeUI: ((Bool) -> ())?
    var data = EditInfomation(action: .relation, textView: UITextView())
    
    var changeDiMungByPopup: Bool = true
    var changeTienNhanByPopup: Bool = true
    
    var closureCanculatorMonney: ((ThongTinKhachMoiModel) -> Void)?
    var closureShowPopup: ((ShowOtherView)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setDelegateTextView()
        setDisplay()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func settingDefault() {
        var data = EditInfomation(action: .relation, textView: relationTextView)
        if infoKM.age == "" {
            data.action = .year_of_birth
            data.textView = ageTextView
            closureDefault?(data)
        }
        if infoKM.address == "" {
            data.action = .address
            data.textView = addressTextView
            closureDefault?(data)
        }
        if infoKM.phone == "" {
            data.action = .phone
            data.textView = phoneTextView
            closureDefault?(data)
        }
        if infoKM.moneyReceived == "" {
            data.action = .monney_received
            data.textView = moneyReceivedTextView
            closureDefault?(data)
        }
        if infoKM.giftMoney == "" {
            data.action = .monney_gift
            data.textView = giftsMonneyTextView
            closureDefault?(data)
        }
        if infoKM.note == "" {
            data.action = .note
            data.textView = noteTextView
            closureDefault?(data)
        }
    }
    
    func setDelegateTextView() {
        relationTextView.delegate = self
        nameTextView.delegate = self
        ageTextView.delegate = self
        addressTextView.delegate = self
        phoneTextView.delegate = self
        moneyReceivedTextView.delegate = self
        giftsMonneyTextView.delegate = self
        oweTextView.delegate = self
        noteTextView.delegate = self
    }
    
    func setDisplay() {
        namSinhTextView.setDefaultTitleField()
        diaChiTextView.setDefaultTitleField()
        sdtTextView.setDefaultTitleField()
        tienNhanTextView.setDefaultTitleField()
        tienDiTextView.setDefaultTitleField()
        noTextView.setDefaultTitleField()
        ghiChuTextView.setDefaultTitleField()
        
        relationTextView.setDefaultFont()
        nameTextView.setDefaultFont()
        ageTextView.setDefaultFont()
        addressTextView.setDefaultFont()
        phoneTextView.setDefaultFont()
        moneyReceivedTextView.setDefaultFont()
        giftsMonneyTextView.setDefaultFont()
        oweTextView.setDefaultFont()
        noteTextView.setDefaultFont()
    }
    
    func fillData() {
        relationTextView.text = infoKM.relation
        nameTextView.text = infoKM.name
        ageTextView.text = infoKM.age
        addressTextView.text = infoKM.address
        phoneTextView.text = infoKM.phone
        
        giftsMonneyTextView.text = infoKM.giftMoney?.toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
        
        moneyReceivedTextView.text = infoKM.moneyReceived?.toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
        if let diMung = infoKM.giftMoney?.toInt(), let nhan = infoKM.moneyReceived?.toInt() {
            let no = diMung - nhan
            oweTextView.text = no.toString().toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
        }
        noteTextView.text = infoKM.note
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        switch textView {
        case giftsMonneyTextView:
            changeDiMungByPopup = false
            editDiMungButton.setImage(#imageLiteral(resourceName: "icons8-delete_sign_filled"), for: .normal)
            if giftsMonneyTextView.text == "0" {
                giftsMonneyTextView.text = ""
            }
        case moneyReceivedTextView:
            changeTienNhanByPopup = false
            editTienNhanButton.setImage(#imageLiteral(resourceName: "icons8-delete_sign_filled"), for: .normal)
            if moneyReceivedTextView.text == "0" {
                moneyReceivedTextView.text = ""
            }
        default:
            break
        }
        if textView == relationTextView || textView == ageTextView {
            data.isShowDropdown = true
        }
        if textView == noteTextView {
            closureChangeUI?(true)
        }
        setValueForClosure(textView)
    }
    //
    func textViewDidChange(_ textView: UITextView) {
        switch textView {
        case moneyReceivedTextView:
            if moneyReceivedTextView.text.hasPrefix("0") {
                moneyReceivedTextView.text = ""
            }
            let d = moneyReceivedTextView.text.replacingOccurrences(of: " ", with: "")
            moneyReceivedTextView.text = d.toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
        case giftsMonneyTextView:
            if giftsMonneyTextView.text.hasPrefix("0") {
                giftsMonneyTextView.text = ""
            }
            let d = giftsMonneyTextView.text.replacingOccurrences(of: " ", with: "")
            giftsMonneyTextView.text = d.toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
            
        default:
            break
        }
        if textView == relationTextView || textView == ageTextView {
            data.isShowDropdown = true
        }
        
        setValueForClosure(textView)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        switch textView {
        case moneyReceivedTextView:
            validateOwe()
        case giftsMonneyTextView:
            validateOwe()
        default:
            break
        }
    }
    
    func validateOwe() {
        if let diMung = giftsMonneyTextView.text, let nhan = moneyReceivedTextView.text {
            let tienMung = diMung.replacingOccurrences(of: " ", with: "").toInt() ?? 0
            let tienNhan = nhan.replacingOccurrences(of: " ", with: "").toInt() ?? 0
            let no = tienMung - tienNhan
            oweTextView.text = no.toString().toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
        }
    }
    
    func setValueForClosure(_ textView: UITextView) {
        switch textView {
        case relationTextView:
            data.action = .relation
            data.textView = relationTextView
        case nameTextView:
            data.action = .name
            data.textView = nameTextView
        case ageTextView:
            data.action = .year_of_birth
            data.textView = ageTextView
        case addressTextView:
            data.action = .address
            data.textView = addressTextView
        case phoneTextView:
            data.action = .phone
            data.textView = phoneTextView
        case moneyReceivedTextView:
            data.action = .monney_received
            data.textView = moneyReceivedTextView
        case giftsMonneyTextView:
            data.action = .monney_gift
            data.textView = giftsMonneyTextView
        case noteTextView:
            data.action = .note
            data.textView = noteTextView
        default:
            break
        }
        closureCurrentChange?(data)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        data.isShowDropdown = false
        if text == "\n" {
            textView.resignFirstResponder()
        }
        switch textView {
        case relationTextView:
            return relationTextView.text.count + (text.count - range.length) <= 20
        case nameTextView:
            return nameTextView.text.count + (text.count - range.length) <= 50
        case ageTextView:
            return ageTextView.text.count + (text.count - range.length) <= 4
        case addressTextView:
            return addressTextView.text.count + (text.count - range.length) <= 70
        case phoneTextView:
            return phoneTextView.text.count + (text.count - range.length) <= 14
        case giftsMonneyTextView:
            return giftsMonneyTextView.text.count + (text.count - range.length) <= 11
        case noteTextView:
            return noteTextView.text.count + (text.count - range.length) <= 4000
        default:
            break
        }
        setValueForClosure(textView)
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        data.isShowDropdown = false
        if textView == moneyReceivedTextView || textView == giftsMonneyTextView {
            if textView.text == "" {
                textView.text = "0"
            }
        }
        if textView == noteTextView {
            closureChangeUI?(false)
        }
        setValueForClosure(textView)
    }
    
    @IBAction func tapEditTienDiMung(_ sender: Any) {
        if changeDiMungByPopup {
//            let vc = Storyboard.Main.popupEditTienMungVC()
//            vc.modalPresentationStyle = .overFullScreen
//            vc.modalTransitionStyle = .crossDissolve
//            vc.infoKM = infoKM
//            vc.editDiMung = true
//            vc.closureFinished = { [weak self] data in
//                self?.giftsMonneyTextView.text = data.toString().toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
//                self?.validateOwe()
//                self?.changeDiMungByPopup = false
//                self?.editDiMungButton.setImage(#imageLiteral(resourceName: "icons8-delete_sign_filled"), for: .normal)
//            }
//            present(vc, animated: true, completion: nil)
            closureShowPopup?(.tien_di_mung)
        } else {
            changeDiMungByPopup = true
            editDiMungButton.setImage(#imageLiteral(resourceName: "icons8-edit_filled"), for: .normal)
            giftsMonneyTextView.text = infoKM.giftMoney?.toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
            validateOwe()
            
//            changeDiMungByPopup = true
//            editDiMungButton.setImage(#imageLiteral(resourceName: "icons8-edit_filled"), for: .normal)
//            giftsMonneyTextView.text = infoKM.giftMoney?.toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
        }
    }
    
    @IBAction func tapEditTienNhan(_ sender: Any) {
        if changeTienNhanByPopup {
            closureShowPopup?(.tien_nhan)
        } else {
            changeTienNhanByPopup = true
            editTienNhanButton.setImage(#imageLiteral(resourceName: "icons8-edit_filled"), for: .normal)
            moneyReceivedTextView.text = infoKM.moneyReceived?.toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
            validateOwe()
        }
    }
    
    @IBAction func tapEditContact(_ sender: Any) {
        closureShowPopup?(.find_contact)
    }
    
}
