//
//  CustomerDetailVC.swift
//  Invitation
//
//  Created by cuongdd on 06/10/2022.
//  Copyright © 2022 Dang Duy Cuong. All rights reserved.
//

import UIKit

class CustomerDetailVC: BaseViewController {
    @IBOutlet weak var titleStatusTextView: UITextView!
    
    //data
    @IBOutlet weak var quanHeTextView: UITextView!
    @IBOutlet weak var tenTextView: UITextView!
    @IBOutlet weak var tuoiTextView: UITextView!
    @IBOutlet weak var phoneTextView: UITextView!
    
    @IBOutlet weak var diaChiTextView: UITextView!
    @IBOutlet weak var diMungTextView: UITextView!
    
    @IBOutlet weak var nhanTextView: UITextView!
    @IBOutlet weak var oweTextView: UITextView!
    @IBOutlet weak var switchStatus: UISwitch!
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBOutlet weak var editDiMungButton: UIButton!
    @IBOutlet weak var editTienNhanButton: UIButton!
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
    
    var changeDiMungByPopup: Bool = true
    var changeTienNhanByPopup: Bool = true
    
    var sourceRelation = ["Anh", "Bố", "Bạn", "Bác", "Chú", "Chị", "Cậu", "Cô", "Con", "Em", "Dì", "Dượng", "Mợ", "Người yêu cũ", "Thím", "Thầy"]
    var listSuggestRelation = [String]()
    let relationDropdown = DropDown()
    
    var listBirth = [String]()
    var suggestBirth = [String]()
    private var viewModel = GuestDetailsViewModel()
    private var ageDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollview.delaysContentTouches = false
        fillData()
        setDelegate()
        
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
        viewModel.setupData(customer: detailKhach)
        
        configDropDown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = "Chi tiết khách mời"
    }
    
    private func configDropDown() {
        ageDropDown.anchorView = tuoiTextView
        ageDropDown.direction = .bottom
        ageDropDown.bottomOffset = CGPoint(x: 0, y: tuoiTextView.bounds.size.height + 8)
        ageDropDown.dismissMode = .onTap
        
        //optional
        if let font = R.font.playfairDisplayRegular(size: 17) {
            ageDropDown.textFont = font
        }
        ageDropDown.separatorColor = .clear
        ageDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.tuoiTextView.text = self.suggestBirth[index]
            self.ageLabel.isHidden = true
            self.tuoiTextView.resignFirstResponder()
        }
        
        relationDropdown.anchorView = quanHeTextView
        relationDropdown.direction = .bottom
        relationDropdown.bottomOffset = CGPoint(x: 0, y: quanHeTextView.bounds.size.height + 8)
        relationDropdown.dismissMode = .onTap
        
        if let font = R.font.playfairDisplayRegular(size: 17) {
            relationDropdown.textFont = font
        }
        relationDropdown.separatorColor = .clear
        relationDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.quanHeTextView.text = self.listSuggestRelation[index]
            self.relationLabel.isHidden = true
            self.quanHeTextView.resignFirstResponder()
        }
    }
    
    private func filterAndShowRelation() {
        if quanHeTextView.text == "" {
            listSuggestRelation = sourceRelation
        } else {
            listSuggestRelation = sourceRelation.filter { text in
                if let keyWord = quanHeTextView.text {
                    if text.unaccent().lowercased().range(of: keyWord.unaccent().lowercased()) != nil {
                        return true
                    }
                }
                return false
            }
        }
        
        relationDropdown.dataSource = listSuggestRelation
        relationDropdown.show()
    }
    
    func filterBirth() {
        if tuoiTextView.text == "" {
            suggestBirth = listBirth
        } else {
            suggestBirth = listBirth.filter { (age: String) in
                if let text = tuoiTextView.text {
                    if age.range(of: text) != nil {
                        return true
                    }
                }
                return false
            }
        }
        ageDropDown.dataSource = suggestBirth
        ageDropDown.show()
    }
    
    func setDisplay() {
        //title font
        
        titleStatusTextView.setDefaultTitleField()
        
        //data font
        quanHeTextView.setDefaultFont()
        tenTextView.setDefaultFont()
        tuoiTextView.setDefaultFont()
        phoneTextView.setDefaultFont()
        
        diaChiTextView.setDefaultFont()
        diMungTextView.setDefaultFont()
        
        nhanTextView.setDefaultFont()
        oweTextView.setDefaultFont()
        noteTextView.setDefaultFont()
        
        //button
        updateButton.setDefaultButton()
    }
    
    func setDelegate() {
        quanHeTextView.delegate = self
        tenTextView.delegate = self
        tuoiTextView.delegate = self
        diaChiTextView.delegate = self
        phoneTextView.delegate = self
        noteTextView.delegate = self
        
        diMungTextView.delegate = self
        nhanTextView.delegate = self
    }
    
    func changeKeyboardTypeDuringRuntime() {
//        if let text = longitudeTextView.text {
//            if text.contains(".") || text.contains(",") {
//                longitudeTextView.text = text.replacingOccurrences(of: ",", with: ".")
//                longitudeTextView.keyboardType = .numberPad
//            } else {
//                longitudeTextView.keyboardType = .decimalPad
//            }
//            longitudeTextView.reloadInputViews()
//        }
//
//        if let text = latitudeTextView.text {
//            if text.contains(".") || text.contains(",") {
//                latitudeTextView.text = text.replacingOccurrences(of: ",", with: ".")
//                latitudeTextView.keyboardType = .numberPad
//            } else {
//                latitudeTextView.keyboardType = .decimalPad
//            }
//            latitudeTextView.reloadInputViews()
//        }
    }
    
    func fillData() {
        quanHeTextView.text = detailKhach.relation
        tenTextView.text = detailKhach.name
        tuoiTextView.text = detailKhach.age
        phoneTextView.text = detailKhach.phone
        diaChiTextView.text = detailKhach.address
        diMungTextView.text = detailKhach.giftMoney?.toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
        nhanTextView.text = detailKhach.moneyReceived?.toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
        
        if let diMung = detailKhach.giftMoney?.toInt(), let nhan = detailKhach.moneyReceived?.toInt() {
            let no = diMung - nhan
            oweTextView.text = no.toString().toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
        }
        
        switchStatus.isOn = detailKhach.status
        noteTextView.text = detailKhach.note
        titleStatusTextView.text = detailKhach.status ? "Đã mời khách" : "Chưa mời khách"
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
            if let closureUpdate = self.closureUpdate {
                self.viewModel.newInfoCustomer.name = self.tenTextView.text
                self.viewModel.newInfoCustomer.age = self.tuoiTextView.text
                self.viewModel.newInfoCustomer.relation = self.quanHeTextView.text
                self.viewModel.newInfoCustomer.giftMoney = self.diMungTextView.text.replacingOccurrences(of: " ", with: "")
                self.viewModel.newInfoCustomer.moneyReceived = self.nhanTextView.text.replacingOccurrences(of: " ", with: "")
                
                if let phone = self.phoneTextView.text {
                    self.viewModel.newInfoCustomer.phone = phone
                }
                self.viewModel.newInfoCustomer.status = self.switchStatus.isOn
                self.viewModel.newInfoCustomer.note = self.noteTextView.text
                closureUpdate(self.viewModel.newInfoCustomer)
            }
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    @IBAction func tapSelectMap(_ sender: Any) {
        guard let vc = R.storyboard.weather.weatherViewController() else {
            return
        }
        vc.infoCustomer = detailKhach
        vc.selectAddress = { [weak self] infoCustomer in
            guard let `self` = self else { return }
            self.diaChiTextView.text = infoCustomer.address
            self.viewModel.updateAddressCustomer(customer: infoCustomer)
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
                guard let `self` = self else {
                    return
                }
                self.diMungTextView.text = data.toString().toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
                self.validateOwe()
                self.changeDiMungByPopup = false
                self.editDiMungButton.setImage(#imageLiteral(resourceName: "icons8-delete_sign_filled"), for: .normal)
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
    
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        titleStatusTextView.text = switchStatus.isOn ? "Đã mời khách" : "Chưa mời khách"
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

extension CustomerDetailVC: UITextViewDelegate {
    //MARK: Delegate TextView
    func textViewDidBeginEditing(_ textView: UITextView) {
        switch textView {
        case quanHeTextView:
            filterAndShowRelation()
        case tuoiTextView:
            filterBirth()
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
        default:
            break
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        relationDropdown.hide()
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
            filterAndShowRelation()
        case tuoiTextView:
            filterBirth()
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


