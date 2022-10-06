//
//  ChiTietGhiNoVC.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/25/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit

class ChiTietGhiNoVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    
    var detailKM = ThongTinKhachMoiModel()
    var updateKM = ThongTinKhachMoiModel()
    
    var scrollKeybard: CGFloat = 0 {
        didSet {
            self.view.frame.origin.y = scrollKeybard
        }
    }
    
    var changing: Bool = false
    let dropdown = DropDown()
    var sourceRelation = ["Anh", "Bố", "Bạn", "Bác", "Chú", "Chị", "Cậu", "Cô", "Con", "Em", "Dì", "Dượng", "Mợ", "Người yêu cũ", "Thím", "Thầy"]
    var listSuggestRelation = [String]()
    var relationLabel = UILabel()
    var nameLabel = UILabel()
    var birthLabel = UILabel()
    var listBirth = [String]()
    var suggestBirth = [String]()
    var addressLabel = UILabel()
    var phoneLabel = UILabel()
    var monneyReceivedLabel = UILabel()
    var giftMoneyLabel = UILabel()
    var noteLabel = UILabel()
    var closureUpdateHistory: ((ThongTinKhachMoiModel) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefaultDataUpdate()
        
        tableView.register(ThongTinChiTietKhachMoiCell.nib(), forCellReuseIdentifier: ThongTinChiTietKhachMoiCell.identifier())
        tableView.keyboardDismissMode = .onDrag
        setShadowButton(button: cancelButton, cornerRadius: 8)
        setShadowButton(button: updateButton, cornerRadius: 8)
        let year = Calendar.current.component(.year, from: Date())
        for item in 1900...year {
            listBirth.append("\(item)")
        }
        navigationBarButtonItems([(.back, .left)])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = "Chi tiết lịch sử mời khách"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if changing {
            tableView.beginUpdates()
        }
    }
    
    func setDefaultDataUpdate() {
        updateKM.id = detailKM.id
        updateKM.name = detailKM.name
        updateKM.age = detailKM.age
        updateKM.address = detailKM.address
        updateKM.phone = detailKM.phone
        updateKM.relation = detailKM.relation
        updateKM.status = detailKM.status
        
        updateKM.latitude = detailKM.latitude
        updateKM.longitude = detailKM.longitude
        updateKM.moneyReceived = detailKM.moneyReceived
        updateKM.giftMoney = detailKM.giftMoney
        
        updateKM.note = detailKM.note
    }
    
    func filterRelation(text: String) {
        if text == "" {
            listSuggestRelation = sourceRelation
        } else {
            listSuggestRelation = sourceRelation.filter { (relation: String) in
                return relation.lowercased().range(of: text.lowercased()) != nil
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
    
}

extension ChiTietGhiNoVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ThongTinChiTietKhachMoiCell.identifier(), for: indexPath) as! ThongTinChiTietKhachMoiCell
        cell.infoKM = detailKM
        cell.fillData()
        cell.closureDefault = { [weak self] data in
            self?.closureDefaultFromCell(data: data)
        }
        cell.settingDefault()
        cell.closureCurrentChange = { [weak self] data in
            self?.tableView.beginUpdates()
            self?.closureFromCell(data: data)
            self?.tableView.endUpdates()
        }
        cell.closureChangeUI = { [weak self] data in
            self?.scrollKeybard = data ? -200 : 0
        }
        cell.closureShowPopup = { [weak self] data in
            switch data {
                case .tien_nhan:
                let vc = Storyboard.Main.popupEditTienMungVC()
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                if let detailKM = self?.detailKM {
                    vc.infoKM = detailKM
                }
                vc.editDiMung = false
                vc.closureFinished = { [weak self] data in
                    cell.moneyReceivedTextView.text = data.toString().toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
                    cell.validateOwe()
                    self?.updateKM.moneyReceived = data.toString()
                    cell.changeTienNhanByPopup = false
                    cell.editTienNhanButton.setImage(#imageLiteral(resourceName: "icons8-delete_sign_filled"), for: .normal)
                }
                self?.present(vc, animated: true, completion: nil)
            case .tien_di_mung:
                let vc = Storyboard.Main.popupEditTienMungVC()
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                if let detailKM = self?.detailKM {
                    vc.infoKM = detailKM
                }
                
                vc.editDiMung = true
                vc.closureFinished = { [weak self] data in
                    cell.giftsMonneyTextView.text = data.toString().toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
                    cell.validateOwe()
                    cell.changeDiMungByPopup = false
                    cell.editDiMungButton.setImage(#imageLiteral(resourceName: "icons8-delete_sign_filled"), for: .normal)
                    self?.updateKM.giftMoney = data.toString()
                }
            
            case .find_contact:
                self?.title = ""
                let vc = Storyboard.Main.phonebookVC()
                vc.closureContact = { [weak self] contact in
                    cell.phoneTextView.text = contact.telephone
                    if cell.nameTextView.text == "" {
                        cell.nameTextView.text = contact.firstName
                    }
                    self?.updateKM.phone = contact.telephone
                }
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return cell
    }
    
    func closureFromCell(data: EditInfomation) {
        if data.isShowDropdown == false {
            dropdown.hide()
        }
        switch data.action {
        case .relation:
            setPlaceholder(textView: data.textView, label: relationLabel, text: "Quan hệ")
            if data.isShowDropdown == true {
                filterRelation(text: data.textView.text)
                showRelation(textView: data.textView)
            }
            
            updateKM.relation = data.textView.text
        case .name:
            setPlaceholder(textView: data.textView, label: nameLabel, text: "Tên khách mời")
            updateKM.name = data.textView.text
        case .year_of_birth:
            setPlaceholder(textView: data.textView, label: birthLabel, text: "Năm sinh")
            if data.isShowDropdown == true {
                filterBirth(text: data.textView.text)
                showBirth(textView: data.textView)
            }
            
            updateKM.age = data.textView.text
        case .address:
            setPlaceholder(textView: data.textView, label: addressLabel, text: "Nhập địa chỉ")
            updateKM.address = data.textView.text
        case .phone:
            setPlaceholder(textView: data.textView, label: phoneLabel, text: "Nhập số điện thoại")
            updateKM.phone = data.textView.text
        case .monney_received:
            setPlaceholder(textView: data.textView, label: monneyReceivedLabel, text: "Nhập tiền nhận")
            updateKM.moneyReceived = data.textView.text
        case .monney_gift:
            setPlaceholder(textView: data.textView, label: giftMoneyLabel, text: "Nhập tiền đi mừng")
            updateKM.giftMoney = data.textView.text
        case .note:
            setPlaceholder(textView: data.textView, label: noteLabel, text: "Nhập ghi chú")
            updateKM.note = data.textView.text
        }
    }
    
    func closureDefaultFromCell(data: EditInfomation) {
        switch data.action {
        case .relation:
            setPlaceholder(textView: data.textView, label: relationLabel, text: "Quan hệ")
        case .name:
            setPlaceholder(textView: data.textView, label: nameLabel, text: "Tên khách mời")
        case .year_of_birth:
            setPlaceholder(textView: data.textView, label: birthLabel, text: "Năm sinh")
        case .address:
            setPlaceholder(textView: data.textView, label: addressLabel, text: "Nhập địa chỉ")
        case .phone:
            setPlaceholder(textView: data.textView, label: phoneLabel, text: "Nhập số điện thoại")
        case .monney_received:
            setPlaceholder(textView: data.textView, label: monneyReceivedLabel, text: "Nhập tiền nhận")
        case .monney_gift:
            setPlaceholder(textView: data.textView, label: giftMoneyLabel, text: "Nhập tiền đi mừng")
        case .note:
            setPlaceholder(textView: data.textView, label: noteLabel, text: "Nhập ghi chú")
        }
    }
    
    func showRelation(textView: UITextView) {
        dropdown.dataSource = listSuggestRelation
        dropdown.anchorView = textView
        dropdown.direction = .bottom
        dropdown.bottomOffset = CGPoint(x: 0, y: textView.bounds.size.height)
        dropdown.dismissMode = .onTap
        
        //optional
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            textView.text = self.listSuggestRelation[index]
            self.relationLabel.isHidden = true
            textView.resignFirstResponder()
        }
        
        dropdown.show()
    }
    
    func showBirth(textView: UITextView) {
        dropdown.dataSource = suggestBirth
        dropdown.anchorView = textView
        dropdown.direction = .bottom
        dropdown.bottomOffset = CGPoint(x: 0, y: textView.bounds.size.height)
        dropdown.dismissMode = .onTap
        
        //optional
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            textView.text = self.suggestBirth[index]
            self.birthLabel.isHidden = true
            textView.resignFirstResponder()
        }
        
        dropdown.show()
    }
    
    @IBAction func tapCancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapUpdate(_ sender: Any) {
        guard checkUpdate() else {
            return
        }
        showAlertWithConfirm(type: .notice, message: "Bạn có chắc chắn muốn cập nhật thông tin đã chỉnh sửa", cancel: {
            
        }, ok: {
            if let closureUpdate = self.closureUpdateHistory {
                closureUpdate(self.editKhachMoi())
            }
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func editKhachMoi() -> ThongTinKhachMoiModel {
        let newInfo = ThongTinKhachMoiModel()
        newInfo.id = detailKM.id
        newInfo.name = updateKM.name
        newInfo.age = updateKM.age
        newInfo.address = updateKM.address
        newInfo.relation = updateKM.relation
        newInfo.longitude = updateKM.longitude
        newInfo.latitude = updateKM.latitude
        
        if let phone = updateKM.phone {
            newInfo.phone = phone
        }
        newInfo.status = detailKM.status
        newInfo.note = updateKM.note
        if let text = updateKM.giftMoney {
            newInfo.giftMoney = text.replacingOccurrences(of: " ", with: "")
        }
        if let text = updateKM.moneyReceived {
            newInfo.moneyReceived = text.replacingOccurrences(of: " ", with: "")
        }
        return newInfo
    }
    
    func checkUpdate() -> Bool {
        if updateKM.relation == "" {
            showAlertViewController(type: .error, message: "Quan hệ với khách mời không được để trống", close: {
                
            })
            return false
        }
        if updateKM.name == "" {
            showAlertViewController(type: .error, message: "Tên khách mời không được để trống", close: {
                
            })
            return false
        }
        
        return true
    }
    
}
