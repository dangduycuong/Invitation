//
//  SettingViewController.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/16/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit
import RealmSwift

enum ActionSetting {
    case change_infomation_user
    case delete_data
    
    static var all = [change_infomation_user, delete_data]
    
    var value: String {
        get {
            switch self {
            case .change_infomation_user:
                return "Đổi thông tin người dùng"
            case .delete_data:
                return "Đang chờ mở rộng"
            }
        }
    }
}

class SettingViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var actionTextField: UITextField!
    @IBOutlet weak var contentStackView: UIStackView!
    
    let dropdown = DropDown()
    let realm = try! Realm()
    
    var showDetailInfo: ActionSetting = .change_infomation_user {
        didSet {
            changeInfomationUserView.isHidden = true
            deleteDataView.isHidden = true
            switch showDetailInfo {
            case .change_infomation_user:
                changeInfomationUserView.isHidden = false
            case .delete_data:
                deleteDataView.isHidden = false
            }
        }
    }
    
    lazy var changeInfomationUserView: UIView = {
        let changeInfomationUserView: ChangeInfomationUserView = ChangeInfomationUserView.loadFromNib()
        //        optionCableView.delegate = self //use clocure
        changeInfomationUserView.frame = contentStackView.bounds
        contentStackView.addArrangedSubview(changeInfomationUserView)
        return changeInfomationUserView
    }()
    
    lazy var deleteDataView: UIView = {
        let deleteDataView: DeleteDataView = DeleteDataView.loadFromNib()
        //        optionCableView.delegate = self //use clocure
        deleteDataView.frame = contentStackView.bounds
        contentStackView.addArrangedSubview(deleteDataView)
        return deleteDataView
    }()
    
    var oldPassword = ""
    var totalKhach = [ThongTinKhachMoiModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionTextField.delegate = self
        actionTextField.placeholder = "--Lựa chọn--"
        if let password = UserDefaults.standard.string(forKey: UserDefaultKey.passwordAuthentication.rawValue) {
            oldPassword = password
        }
        getAll()
        navigationBarButtonItems([(.back, .left)])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = "Cài đặt"
    }
    
    override func back(_ sender: UIBarButtonItem) {
        backVC(controller: Storyboard.MainSlide.mainSlideMenuViewController())
    }
    
    func getAll() {
//        let results = realm.objects(ThongTinKhachMoiModel.self).sorted(byKeyPath: "ten", ascending: true).toArray(ofType: ThongTinKhachMoiModel.self)
//        print(results.count)
//        totalKhach = results
        
//        if let deleteView = deleteDataView as? DeleteDataView {
//            deleteView.listKM = totalKhach
//            deleteView.isHidden = true
//        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        actionTextField.text = ""
        actionTextField.resignFirstResponder()
        dropdown.dataSource = ActionSetting.all.map { $0.value }
        dropdown.anchorView = actionTextField
        dropdown.direction = .bottom
        dropdown.bottomOffset = CGPoint(x: 0, y: actionTextField.bounds.size.height)
        dropdown.dismissMode = .onTap
        
        //optional
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.actionTextField.text = ActionSetting.all[index].value
            self.setupSetting(self.showDetailInfo)
            self.showDetailInfo = ActionSetting.all[index]
        }
        
        dropdown.show()
    }
    
    func setupSetting(_ sender: ActionSetting) {
        switch sender {
        case .change_infomation_user:
            if let changeInfomationUserView = changeInfomationUserView as? ChangeInfomationUserView {
                changeInfomationUserView.closureUpdateUser = { [weak self] data in
                    if let result = self?.updateUser(data) {
                        if result {
                            UserDefaults.standard.set(data.username, forKey: UserDefaultKey.usernameAuthentication.rawValue)
                            UserDefaults.standard.set(data.new_password, forKey: UserDefaultKey.passwordAuthentication.rawValue)
                            self?.showAlertViewController(type: .notice, message: "Cập nhật thông tin người dùng thành công", close: {
                                self?.showDetailInfo = .delete_data
                                self?.oldPassword = data.new_password ?? ""
                            })
                        }
                    }
                }
            }
        case .delete_data:
            showDetailInfo = .delete_data
//            if let delete = deleteDataView as? DeleteDataView {
//                delete.tableView.reloadData()
//            }
        }
    }
    
    func updateUser(_ data: DataUser) -> Bool {
        if data.username == "" {
            showAlertViewController(type: .error, message: "Chưa nhập tên đăng nhập. Điền tên đăng nhập trước", close: {
                
            })
            return false
        }
        if data.old_password != oldPassword {
            showAlertViewController(type: .error, message: "Nhập sai mật khẩu cũ", close: {
                
            })
            return false
        }
        if data.new_password == "" {
            showAlertViewController(type: .error, message: "Chưa nhập mật khẩu mới. Nhập mật khẩu mới trước", close: {
                
            })
            return false
        }
        if data.repeat_password != data.new_password {
            showAlertViewController(type: .error, message: "Nhập lại mật khẩu mới sai", close: {
                
            })
            return false
        }
        return true
    }
    
}
