//
//  ThemKhachMoiVC.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 11/26/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit
import RealmSwift

class ThemKhachMoiVC: BaseViewController, UITextViewDelegate {
    @IBOutlet weak var titleNameInviteeTextView: UITextView!
    @IBOutlet weak var ageInviteeTextView: UITextView!
    @IBOutlet weak var titleAddressTextView: UITextView!
    @IBOutlet weak var titlePhoneTextView: UITextView!
    @IBOutlet weak var titleRelationTextView: UITextView!
    
    @IBOutlet weak var titleNoteTextView: UITextView!
    
    @IBOutlet weak var tenKhachMoiTextView: UITextView!
    @IBOutlet weak var tienMungTextView: UITextView!
    @IBOutlet weak var tienNhanTextView: UITextView!
    
    
    @IBOutlet weak var tuoiTextView: UITextView!
    @IBOutlet weak var diaChiTextView: UITextView!
    @IBOutlet weak var phoneTextView: UITextView!
    
    @IBOutlet weak var quanHeTextView: UITextView!
    @IBOutlet weak var chiTietQuanHeTextView: UITextView!
    @IBOutlet weak var moneyReceivedTextView: UITextView!
    @IBOutlet weak var giftMoneyTextView: UITextView!
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    var firstEnterName: Bool = true
    var listSuggestRelation = [String]()
    var sourceRelation = ["Anh", "Bố", "Bạn", "Bác", "Chú", "Chị", "Cậu", "Cô", "Con", "Em", "Dì", "Dượng", "Mợ", "Người yêu cũ", "Thím", "Thầy"]
    
    var totalItem: Int = 0
    let realm = try! Realm()
    var listKhachMoi = [ThongTinKhachMoiModel]()
    var dropdown = DropDown()
    var titleString: String?
    
    var tenLabel: UILabel!
    var tuoiLabel: UILabel!
    var diaChiLabel: UILabel!
    var dienThoaiLabel: UILabel!
    var quanHeLabel: UILabel!
    var noteLabel = UILabel()
    
    var tienMungLabel = UILabel()
    var tienNhanLabel = UILabel()
    
    var dataKM = ThongTinKhachMoiModel()
    
    var scrollKeybard: CGFloat = 0 {
        didSet {
            self.view.frame.origin.y = scrollKeybard
        }
    }
    var listBirth = [String]()
    var suggestBirth = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isEnableHideKeyBoardWhenTouchInScreen = true
        print(Realm.Configuration.defaultConfiguration)
        
        generalPlaceHolder()
        setDelegate()
        setFont()
        setShadowButton(button: cancelButton, cornerRadius: 8)
        setShadowButton(button: addButton, cornerRadius: 8)
//        var text: String? = "10000099999"
//        moneyReceivedTextView.text = text?.toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
        navigationController?.navigationBar.isHidden = false
        tenKhachMoiTextView.becomeFirstResponder()
        let year = Calendar.current.component(.year, from: Date())
        for item in 1900...year {
            listBirth.append("\(item)")
        }
        navigationBarButtonItems([(ItemType.back, ItemPosition.left)])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setDisplay()
    }
    
    override func back(_ sender: UIBarButtonItem) {
        back()
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
            self.tuoiLabel.isHidden = true
            self.diaChiTextView.becomeFirstResponder()
        }
        
        dropdown.show()
    }
    
    func setFont() {
        titleNameInviteeTextView.setDefaultTitleField()
        ageInviteeTextView.setDefaultTitleField()
        titleAddressTextView.setDefaultTitleField()
        titlePhoneTextView.setDefaultTitleField()
        titleRelationTextView.setDefaultTitleField()
        quanHeTextView.setDefaultTitleField()
        titleNoteTextView.setDefaultTitleField()
        
        tienMungTextView.setDefaultTitleField()
        tienNhanTextView.setDefaultTitleField()
        
        tenKhachMoiTextView.setDefaultFont()
        tuoiTextView.setDefaultFont()
        diaChiTextView.setDefaultFont()
        phoneTextView.setDefaultFont()
        chiTietQuanHeTextView.setDefaultFont()
        
        moneyReceivedTextView.setDefaultFont()
        giftMoneyTextView.setDefaultFont()
    }
    
    func setDelegate() {
        tenKhachMoiTextView.delegate = self
        tuoiTextView.delegate = self
        diaChiTextView.delegate = self
        quanHeTextView.delegate = self
        chiTietQuanHeTextView.delegate = self
        phoneTextView.delegate = self
        noteTextView.delegate = self
        
        giftMoneyTextView.delegate = self
        moneyReceivedTextView.delegate = self
    }
    
    func setDisplay() {
        if let titleString = titleString {
            title = titleString
        }
        title = "Thêm khách mời"
    }
    
    func generalPlaceHolder() {
        tenLabel = UILabel()
        tuoiLabel = UILabel()
        diaChiLabel = UILabel()
        dienThoaiLabel = UILabel()
        quanHeLabel = UILabel()
        
        setPlaceholder(textView: tenKhachMoiTextView, label: tenLabel, text: "Nhập tên khách mời")
        setPlaceholder(textView: tuoiTextView, label: tuoiLabel, text: "Nhập năm sinh")
        setPlaceholder(textView: diaChiTextView, label: diaChiLabel, text: "Nhập địa chỉ")
        setPlaceholder(textView: phoneTextView, label: dienThoaiLabel, text: "Nhập điện thoại")
        setPlaceholder(textView: chiTietQuanHeTextView, label: quanHeLabel, text: "Chi tiết quan hệ")
        setPlaceholder(textView: noteTextView, label: noteLabel, text: "Nhập ghi chú (không bắt buộc)")
        
        setPlaceholder(textView: giftMoneyTextView, label: tienMungLabel, text: "Nhập tiền mừng (không bắt buộc)")
        setPlaceholder(textView: moneyReceivedTextView, label: tienNhanLabel, text: "Nhập tiền nhận (không bắt buộc)")
    }
    
    func validateCustomer() -> Bool {
        if tenKhachMoiTextView.text == "" {
            showAlertViewController(type: .error, message: "Chưa nhập tên khách mời. Tên khách mời bắt buộc nhập", close: {
                self.tenKhachMoiTextView.becomeFirstResponder()
            })
            return false
        }
        if chiTietQuanHeTextView.text == "" {
            showAlertViewController(type: .error, message: "Chưa nhập quan hệ với khách mời. Bắt buộc nhập", close: {
                self.chiTietQuanHeTextView.becomeFirstResponder()
            })
            return false
        }
        return true
    }
    
    // MARK: - Action
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    func showRelation() {
        dropdown.dataSource = listSuggestRelation
        dropdown.anchorView = chiTietQuanHeTextView
        dropdown.direction = .top
        dropdown.topOffset = CGPoint(x: 0, y: -chiTietQuanHeTextView.bounds.size.height)
        dropdown.dismissMode = .onTap
        
        //optional
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.chiTietQuanHeTextView.text = self.listSuggestRelation[index]
            self.chiTietQuanHeTextView.resignFirstResponder()
        }
        
        dropdown.show()
    }
    
    @IBAction func tapSelectInMap(_ sender: Any) {
        title = ""
        let vc = Storyboard.Main.chonDiaDiemVC()
        vc.titleString = "Nhà khách mời"
        vc.passCoordinate = { [weak self] infoKM in
            self?.dataKM.longitude = infoKM.longitude
            self?.dataKM.latitude = infoKM.latitude
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        switch textView {
        case tuoiTextView:
            if let text = tuoiTextView.text {
                filterBirth(text: text)
                showBirth(textView: tuoiTextView)
            }
        case tenKhachMoiTextView:
            if firstEnterName {
                firstEnterName = false
                tenKhachMoiTextView.resignFirstResponder()
            }
        case quanHeTextView:
            quanHeTextView.resignFirstResponder()
        //            showRelation()
        case chiTietQuanHeTextView:
            filterRelation()
            showRelation()
        //            scrollKeybard = -100
        case noteTextView:
            scrollKeybard = -200
        default:
            break
        }
    }
    
    func filterRelation() {
        if chiTietQuanHeTextView.text == "" {
            listSuggestRelation = sourceRelation
        } else {
            listSuggestRelation = sourceRelation.filter { (relation: String) in
                if let key = chiTietQuanHeTextView.text {
                    return relation.lowercased().range(of: key.lowercased()) != nil
                }
                return false
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        switch textView {
        case tuoiTextView:
            if let text = tuoiTextView.text {
                filterBirth(text: text)
                showBirth(textView: tuoiTextView)
            }
        case giftMoneyTextView:
            if giftMoneyTextView.text.hasPrefix("0") {
                giftMoneyTextView.text = ""
            }
            let d = giftMoneyTextView.text.replacingOccurrences(of: " ", with: "")
            giftMoneyTextView.text = d.toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
        case moneyReceivedTextView:
            if moneyReceivedTextView.text.hasPrefix("0") {
                moneyReceivedTextView.text = ""
            }
            let d = moneyReceivedTextView.text.replacingOccurrences(of: " ", with: "")
            moneyReceivedTextView.text = d.toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
        case chiTietQuanHeTextView:
            filterRelation()
            showRelation()
        default:
            break
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        switch textView {
        case tenKhachMoiTextView:
            tenLabel.isHidden = !tenKhachMoiTextView.text.isEmpty
        case tuoiTextView:
            tuoiLabel.isHidden = !tuoiTextView.text.isEmpty
        case diaChiTextView:
            diaChiLabel.isHidden = !diaChiTextView.text.isEmpty
        case chiTietQuanHeTextView:
            quanHeLabel.isHidden = !chiTietQuanHeTextView.text.isEmpty
        case phoneTextView:
            dienThoaiLabel.isHidden = phoneTextView.text != ""
        case noteTextView:
            noteLabel.isHidden = !noteTextView.text.isEmpty
        case giftMoneyTextView:
            tienMungLabel.isHidden = !giftMoneyTextView.text.isEmpty
        case moneyReceivedTextView:
            tienNhanLabel.isHidden = !moneyReceivedTextView.text.isEmpty
        default:
            break
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            switch textView {
            case tenKhachMoiTextView:
                tuoiTextView.becomeFirstResponder()
            case tuoiTextView:
                diaChiTextView.becomeFirstResponder()
            case quanHeTextView:
                phoneTextView.becomeFirstResponder()
            case diaChiTextView:
                phoneTextView.becomeFirstResponder()
            case chiTietQuanHeTextView:
                dropdown.hide()
                noteTextView.becomeFirstResponder()
            default:
                textView.resignFirstResponder()
            }
        }
        switch textView {
        case tenKhachMoiTextView:
            return tenKhachMoiTextView.text.count + (text.count - range.length) <= 50
        case tuoiTextView:
            return tuoiTextView.text.count + (text.count - range.length) <= 4
        case phoneTextView:
            return phoneTextView.text.count + (text.count - range.length) <= 14
        case diaChiTextView:
            return diaChiTextView.text.count + (text.count - range.length) <= 70
        case giftMoneyTextView:
            return giftMoneyTextView.text.count + (text.count - range.length) <= 11
        case moneyReceivedTextView:
            return moneyReceivedTextView.text.count + (text.count - range.length) <= 11
        case chiTietQuanHeTextView:
            return chiTietQuanHeTextView.text.count + (text.count - range.length) <= 25
        default:
            break
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        scrollKeybard = 0
    }
    
    @IBAction func tapGetContact(_ sender: Any) {
        title = ""
        let vc = Storyboard.Main.phonebookVC()
        vc.closureContact = { [weak self] contact in
            self?.phoneTextView.text = contact.telephone
            if self?.tenKhachMoiTextView.text == "" {
                self?.tenKhachMoiTextView.text = contact.firstName
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapCancel(_ sender: Any) {
//        navigationController?.popViewController(animated: true)
        back()
    }
    
    func back(){
        DispatchQueue.main.async {
            let mainSlideMenuViewController = Storyboard.MainSlide.mainSlideMenuViewController()
            let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            
            keyWindow?.rootViewController = mainSlideMenuViewController
            keyWindow?.endEditing(true) //co cung thay chay ma bo di cung chay
        }
    }
    
    @IBAction func tapAdd(_ sender: Any) {
        guard validateCustomer() else {
            return
        }
        let newUser = ThongTinKhachMoiModel()
        newUser.id = String.random()
        
        newUser.ten = tenKhachMoiTextView.text
        newUser.tuoi = tuoiTextView.text
        newUser.dia_chi = diaChiTextView.text
        newUser.quan_he = chiTietQuanHeTextView.text
        if let phone = phoneTextView.text {
            newUser.phone = phone
        }
        
        newUser.longitude = dataKM.longitude
        newUser.latitude = dataKM.latitude
        newUser.note = noteTextView.text
        
        if let text = giftMoneyTextView.text {
            let value = text.replacingOccurrences(of: " ", with: "")
            newUser.giftMoney = value == "" ? "0" : value
        }
        
        if let text = moneyReceivedTextView.text {
            let value = text.replacingOccurrences(of: " ", with: "")
            newUser.moneyReceived = value == "" ? "0" : value
        }
        
        let results = realm.objects(ThongTinKhachMoiModel.self)
        totalItem = results.count
        
        try! realm.write {
            realm.add(newUser)
        }
        
        if results.count == totalItem + 1 {
            totalItem += 1
            showAlertViewController(type: .notice, message: "Thêm khách mời thành công", close: {
                self.cleanData()
            })
        }
    }
    
    func cleanData() {
        tenKhachMoiTextView.text = ""
        tuoiTextView.text = ""
        diaChiTextView.text = ""
        phoneTextView.text = ""
        chiTietQuanHeTextView.text = ""
        moneyReceivedTextView.text = ""
        giftMoneyTextView.text = ""
        noteTextView.text = ""
        firstEnterName = true
        tenKhachMoiTextView.becomeFirstResponder()
        tenLabel.isHidden = !tenKhachMoiTextView.text.isEmpty
    }
    
    func addObjectToRealm() {
        //        https://stackoverflow.com/questions/58976630/swift-realm-completion-after-successfully-adding-item
    }
    
}
