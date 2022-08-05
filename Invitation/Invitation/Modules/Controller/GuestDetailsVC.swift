//
//  GuestDetailsVC.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/25/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class GuestDetailsVC: BaseViewController {
    
    //title
    @IBOutlet weak var titleAgeTextView: UITextView!
    @IBOutlet weak var titlePhoneTextView: UITextView!
    @IBOutlet weak var titleAddressTextView: UITextView!
    @IBOutlet weak var titleLongitudeTextView: UITextView!
    
    @IBOutlet weak var titleLatitudeTextView: UITextView!
    @IBOutlet weak var titleDiMungTextView: UITextView!
    @IBOutlet weak var titleNhanTextView: UITextView!
    @IBOutlet weak var titleNoTextView: UITextView!
    
    @IBOutlet weak var titleStatusTextView: UITextView!
    @IBOutlet weak var titleNoteTextView: UITextView!
    
    //data
    @IBOutlet weak var quanHeTextView: UITextView!
    @IBOutlet weak var tenTextView: UITextView!
    @IBOutlet weak var tuoiTextView: UITextView!
    @IBOutlet weak var phoneTextView: UITextView!
    
    @IBOutlet weak var diaChiTextView: UITextView!
    @IBOutlet weak var longitudeTextView: UITextView!
    @IBOutlet weak var latitudeTextView: UITextView!
    @IBOutlet weak var diMungTextView: UITextView!
    
    @IBOutlet weak var nhanTextView: UITextView!
    @IBOutlet weak var oweTextView: UITextView!
    @IBOutlet weak var switchStatus: UISwitch!
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBOutlet weak var editDiMungButton: UIButton!
    @IBOutlet weak var editTienNhanButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var scrollview: UIScrollView!
    
    fileprivate let application = UIApplication.shared
    var detailKhach = ThongTinKhachMoiModel()
    var closureUpdate: ((ThongTinKhachMoiModel) -> ())?
    
    var relationLabel = UILabel()
    var nameLabel = UILabel()
    var ageLabel = UILabel()
    var phoneLabel = UILabel()
    var addressLabel = UILabel()
    var noteLabel = UILabel()
    var tienDiMungLabel = UILabel()
    var tienKhachMungLabel = UILabel()
    
    var scrollKeybard: CGFloat = 0 {
        didSet {
            self.view.frame.origin.y = scrollKeybard
        }
    }
    
    var changeDiMungByPopup: Bool = true
    var changeTienNhanByPopup: Bool = true
    
    var sourceRelation = ["Anh", "Bố", "Bạn", "Bác", "Chú", "Chị", "Cậu", "Cô", "Con", "Em", "Dì", "Dượng", "Mợ", "Người yêu cũ", "Thím", "Thầy"]
    var listSuggestRelation = [String]()
    let dropdown = DropDown()
    
    var listBirth = [String]()
    var suggestBirth = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollview.delaysContentTouches = false
        fillData()
        setDelegate()
        isEnableHideKeyBoardWhenTouchInScreen = true
        
        let year = Calendar.current.component(.year, from: Date())
        for item in 1900...year {
            listBirth.append("\(item)")
        }
        
        setPlaceholder(textView: quanHeTextView, label: relationLabel, text: "Quan hệ")
        setPlaceholder(textView: tenTextView, label: nameLabel, text: "Tên khách mời")
        setPlaceholder(textView: tuoiTextView, label: ageLabel, text: "Năm sinh")
        setPlaceholder(textView: phoneTextView, label: phoneLabel, text: "Số điện thoại")
        setPlaceholder(textView: diaChiTextView, label: addressLabel, text: "Địa chỉ")
        setPlaceholder(textView: noteTextView, label: noteLabel, text: "Nhập ghi chú (không bắt buộc)")
        setPlaceholder(textView: nhanTextView, label: tienKhachMungLabel, text: "Tiền khách mừng")
        setPlaceholder(textView: diMungTextView, label: tienDiMungLabel, text: "Tiền đi mừng")
        switchStatus.set(width: 45, height: 25)
        setDisplay()
        navigationBarButtonItems([(.back, .left)])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = "Chi tiết khách mời"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func filterRelation() {
        if quanHeTextView.text == "" {
            listSuggestRelation = sourceRelation
        } else {
            listSuggestRelation = sourceRelation.filter { (relation: String) in
                if let text = quanHeTextView.text {
                    let content = relation.lowercased()
                    let key = text.lowercased()
                    if content.range(of: key) != nil {
                        return true
                    }
                }
                
                return false
            }
        }
    }
    
    func filterBirth(text: String) {
        if text == "" {
            suggestBirth = listBirth
        } else {
            suggestBirth = listBirth.filter { (relation: String) in
                return relation.lowercased().range(of: text.lowercased()) != nil
            }
        }
    }
    
    func showRelation() {
        dropdown.dataSource = listSuggestRelation
        dropdown.anchorView = quanHeTextView
        dropdown.direction = .bottom
        dropdown.bottomOffset = CGPoint(x: 0, y: quanHeTextView.bounds.size.height)
        dropdown.dismissMode = .onTap
        
        //optional
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.quanHeTextView.text = self.listSuggestRelation[index]
            self.relationLabel.isHidden = true
            self.quanHeTextView.resignFirstResponder()
        }
        
        dropdown.show()
    }
    
    func showBirth() {
        dropdown.dataSource = suggestBirth
        dropdown.anchorView = tuoiTextView
        dropdown.direction = .bottom
        dropdown.bottomOffset = CGPoint(x: 0, y: tuoiTextView.bounds.size.height)
        dropdown.dismissMode = .onTap
        
        //optional
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.tuoiTextView.text = self.suggestBirth[index]
            self.ageLabel.isHidden = true
            self.tuoiTextView.resignFirstResponder()
        }
        
        dropdown.show()
    }
    
    func setDisplay() {
        //title font
        titleAgeTextView.setDefaultTitleField()
        titlePhoneTextView.setDefaultTitleField()
        titleAddressTextView.setDefaultTitleField()
        titleLongitudeTextView.setDefaultTitleField()
        
        titleLatitudeTextView.setDefaultTitleField()
        titleDiMungTextView.setDefaultTitleField()
        titleNhanTextView.setDefaultTitleField()
        titleNoTextView.setDefaultTitleField()
        
        titleStatusTextView.setDefaultTitleField()
        titleNoteTextView.setDefaultTitleField()
        
        //data font
        quanHeTextView.setDefaultFont()
        tenTextView.setDefaultFont()
        tuoiTextView.setDefaultFont()
        phoneTextView.setDefaultFont()
        
        diaChiTextView.setDefaultFont()
        longitudeTextView.setDefaultFont()
        latitudeTextView.setDefaultFont()
        diMungTextView.setDefaultFont()
        
        nhanTextView.setDefaultFont()
        oweTextView.setDefaultFont()
        noteTextView.setDefaultFont()
        
        //button
        cancelButton.setDefaultButton()
        updateButton.setDefaultButton()
    }
    
    func setDelegate() {
        quanHeTextView.delegate = self
        tenTextView.delegate = self
        tuoiTextView.delegate = self
        diaChiTextView.delegate = self
        phoneTextView.delegate = self
        longitudeTextView.delegate = self
        latitudeTextView.delegate = self
        noteTextView.delegate = self
        
        diMungTextView.delegate = self
        nhanTextView.delegate = self
    }
    
    func changeKeyboardTypeDuringRuntime() {
        if let text = longitudeTextView.text {
            if text.contains(".") || text.contains(",") {
                longitudeTextView.text = text.replacingOccurrences(of: ",", with: ".")
                longitudeTextView.keyboardType = .numberPad
            } else {
                longitudeTextView.keyboardType = .decimalPad
            }
            longitudeTextView.reloadInputViews()
        }
        
        if let text = latitudeTextView.text {
            if text.contains(".") || text.contains(",") {
                latitudeTextView.text = text.replacingOccurrences(of: ",", with: ".")
                latitudeTextView.keyboardType = .numberPad
            } else {
                latitudeTextView.keyboardType = .decimalPad
            }
            latitudeTextView.reloadInputViews()
        }
    }
    
    func fillData() {
        quanHeTextView.text = detailKhach.quan_he
        tenTextView.text = detailKhach.ten
        tuoiTextView.text = detailKhach.tuoi
        phoneTextView.text = detailKhach.phone
        diaChiTextView.text = detailKhach.dia_chi
        longitudeTextView.text = "\(detailKhach.longitude)"
        latitudeTextView.text = "\(detailKhach.latitude)"
        diMungTextView.text = detailKhach.giftMoney?.toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
        nhanTextView.text = detailKhach.moneyReceived?.toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
        
        if let diMung = detailKhach.giftMoney?.toInt(), let nhan = detailKhach.moneyReceived?.toInt() {
            let no = diMung - nhan
            oweTextView.text = no.toString().toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
        }
        
        switchStatus.isOn = detailKhach.status
        noteTextView.text = detailKhach.note
    }
    
    func editKhachMoi() -> ThongTinKhachMoiModel {
        let newInfo = ThongTinKhachMoiModel()
        newInfo.id = detailKhach.id
        newInfo.ten = tenTextView.text
        newInfo.tuoi = tuoiTextView.text
        newInfo.dia_chi = diaChiTextView.text
        newInfo.quan_he = quanHeTextView.text
        if let longitude = longitudeTextView.text.toDouble(), let latitude = latitudeTextView.text.toDouble() {
            newInfo.longitude = longitude
            newInfo.latitude = latitude
        }
        newInfo.giftMoney = diMungTextView.text.replacingOccurrences(of: " ", with: "")
        newInfo.moneyReceived = nhanTextView.text.replacingOccurrences(of: " ", with: "")
        
        if let phone = phoneTextView.text {
            newInfo.phone = phone
        }
        newInfo.status = switchStatus.isOn
        newInfo.note = noteTextView.text
        
        return newInfo
    }
    
    @IBAction func tapCancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func checkUpdate() -> Bool {
        if tenTextView.text == "" {
            showAlertViewController(type: .error, message: "Tên khách mời không được để trống", close: {
                
            })
            return false
        }
        
        if quanHeTextView.text == "" {
            showAlertViewController(type: .error, message: "Quan hệ với khách mời không được để trống", close: {
                
            })
            return false
        }
        return true
    }
    
    @IBAction func tapUpdate(_ sender: Any) {
        guard checkUpdate() else {
            return
        }
        showAlertWithConfirm(type: .notice, message: "Bạn chắc chắn muốn cập nhật thông tin đã chỉnh sửa", cancel: {
            
        }, ok: {
            //            self.editKhachMoi()
            if let closureUpdate = self.closureUpdate {
                closureUpdate(self.editKhachMoi())
            }
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    @IBAction func tapSelectMap(_ sender: Any) {
        title = ""
        let vc = Storyboard.Main.chonDiaDiemVC()
        vc.titleString = "Nhà khách mời"
        vc.passCoordinate = { [weak self] infoKM in
            self?.longitudeTextView.text = "\(infoKM.longitude)"
            self?.latitudeTextView.text = "\(infoKM.latitude)"
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapCalling(_ sender: Any) {
        calling()
    }
    
    func calling() {
        let urlSchema = "tel:"
        guard let numberToCall = phoneTextView.text else { return }
        if let numberToCallURL = URL(string: "\(urlSchema)\(String(describing: numberToCall))") {
            if UIApplication.shared.canOpenURL(numberToCallURL) {
                application.open(numberToCallURL, options: [:], completionHandler: nil)
            } else {
                // show alert
            }
        }
    }
    
    @IBAction func tapGetContact(_ sender: Any) {
        title = ""
        let vc = Storyboard.Main.phonebookVC()
        vc.closureContact = { [weak self] contact in
            self?.phoneTextView.text = contact.telephone
            if self?.tenTextView.text == "" {
                self?.tenTextView.text = contact.firstName
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapEditTienDiMung(_ sender: Any) {
        if changeDiMungByPopup {
            let vc = Storyboard.Main.popupEditTienMungVC()
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.infoKM = detailKhach
            vc.editDiMung = true
            vc.closureFinished = { [weak self] data in
                self?.diMungTextView.text = data.toString().toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
                self?.validateOwe()
                self?.changeDiMungByPopup = false
                self?.editDiMungButton.setImage(#imageLiteral(resourceName: "icons8-delete_sign_filled"), for: .normal)
            }
            present(vc, animated: true, completion: nil)
        } else {
            changeDiMungByPopup = true
            editDiMungButton.setImage(#imageLiteral(resourceName: "icons8-edit_filled"), for: .normal)
            diMungTextView.text = detailKhach.giftMoney?.toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
            validateOwe()
        }
    }
    
    @IBAction func tapEditTienNhan(_ sender: Any) {
        if changeTienNhanByPopup {
            let vc = Storyboard.Main.popupEditTienMungVC()
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.infoKM = detailKhach
            vc.editDiMung = false
            vc.closureFinished = { [weak self] data in
                self?.nhanTextView.text = data.toString().toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
                self?.validateOwe()
                self?.changeTienNhanByPopup = false
                self?.editTienNhanButton.setImage(#imageLiteral(resourceName: "icons8-delete_sign_filled"), for: .normal)
            }
            present(vc, animated: true, completion: nil)
        } else {
            changeTienNhanByPopup = true
            editTienNhanButton.setImage(#imageLiteral(resourceName: "icons8-edit_filled"), for: .normal)
            nhanTextView.text = detailKhach.moneyReceived?.toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
            validateOwe()
        }
    }
    
    
    
    func validateOwe() {
        if let diMung = diMungTextView.text, let nhan = nhanTextView.text {
            let tienMung = diMung.replacingOccurrences(of: " ", with: "").toInt() ?? 0
            let tienNhan = nhan.replacingOccurrences(of: " ", with: "").toInt() ?? 0
            let no = tienMung - tienNhan
            oweTextView.text = no.toString().toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        scrollKeybard = 0
        switch textView {
        case diMungTextView:
            if diMungTextView.text == "" {
                diMungTextView.text = "0"
            }
        case nhanTextView:
            if nhanTextView.text == "" {
                nhanTextView.text = "0"
            }
        default:
            break
        }
    }
    
}

extension GuestDetailsVC: UITextViewDelegate {
    //MARK: Delegate TextView
    func textViewDidBeginEditing(_ textView: UITextView) {
        switch textView {
        case quanHeTextView:
            filterRelation()
            showRelation()
        case tuoiTextView:
            if let text = tuoiTextView.text {
                filterBirth(text: text)
                showBirth()
            }
        case diMungTextView:
            changeDiMungByPopup = false
            editDiMungButton.setImage(#imageLiteral(resourceName: "icons8-delete_sign_filled"), for: .normal)
            if diMungTextView.text == "0" {
                diMungTextView.text = ""
            }
        case nhanTextView:
            changeTienNhanByPopup = false
            editTienNhanButton.setImage(#imageLiteral(resourceName: "icons8-delete_sign_filled"), for: .normal)
            if nhanTextView.text == "0" {
                nhanTextView.text = ""
            }
        case noteTextView:
            scrollKeybard = -200
        case longitudeTextView:
            changeKeyboardTypeDuringRuntime()
        case latitudeTextView:
            changeKeyboardTypeDuringRuntime()
        default:
            break
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        dropdown.hide()
        switch textView {
        case tenTextView:
            return tenTextView.text.count + (text.count - range.length) <= 50
        case tuoiTextView:
            return tuoiTextView.text.count + (text.count - range.length) <= 4
        case phoneTextView:
            return phoneTextView.text.count + (text.count - range.length) <= 14
        case diMungTextView:
            return diMungTextView.text.count + (text.count - range.length) <= 11
        case nhanTextView:
            return nhanTextView.text.count + (text.count - range.length) <= 11
        default:
            break
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        switch textView {
        case quanHeTextView:
            filterRelation()
            showRelation()
        case tuoiTextView:
            if let text = tuoiTextView.text {
                filterBirth(text: text)
                showBirth()
            }
        case longitudeTextView:
            changeKeyboardTypeDuringRuntime()
        case latitudeTextView:
            changeKeyboardTypeDuringRuntime()
        case diMungTextView:
            if diMungTextView.text.hasPrefix("0") {
                diMungTextView.text = ""
            }
            let d = diMungTextView.text.replacingOccurrences(of: " ", with: "")
            diMungTextView.text = d.toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
        case nhanTextView:
            if nhanTextView.text.hasPrefix("0") {
                nhanTextView.text = ""
            }
            let d = nhanTextView.text.replacingOccurrences(of: " ", with: "")
            nhanTextView.text = d.toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
        default:
            break
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        switch textView {
        case quanHeTextView:
            relationLabel.isHidden = !quanHeTextView.text.isEmpty
        case tenTextView:
            nameLabel.isHidden = !tenTextView.text.isEmpty
        case tuoiTextView:
            ageLabel.isHidden = !tuoiTextView.text.isEmpty
        case phoneTextView:
            phoneLabel.isHidden = !phoneTextView.text.isEmpty
        case diaChiTextView:
            addressLabel.isHidden = !diaChiTextView.text.isEmpty
        case diMungTextView:
            tienDiMungLabel.isHidden = !diMungTextView.text.isEmpty
            validateOwe()
        case nhanTextView:
            tienKhachMungLabel.isHidden = !nhanTextView.text.isEmpty
            validateOwe()
        case noteTextView:
            noteLabel.isHidden = !noteTextView.text.isEmpty
        default:
            break
        }
    }
}
