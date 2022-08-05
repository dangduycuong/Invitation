//
//  HistoryVC.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/9/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit
import RealmSwift

class HistoryVC: BaseViewController, UITextFieldDelegate {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var displayItemSelectLabel: UILabel!
    @IBOutlet weak var selectAllItemImageView: UIImageView!
    
    var loaiKhach = LoaiKhach.tat_ca
    var countDisplay: Int = 0 {
        didSet {
            pageLabel.text = "\(countDisplay)"
        }
    }
    var totalKhach = [ThongTinKhachMoiModel]()
    var listConNo = [ThongTinKhachMoiModel]()
    var listHetNo = [ThongTinKhachMoiModel]()
    var suggestKhachMoi = [ThongTinKhachMoiModel]()
    let realm = try! Realm()
    
    var isSelectAllItem: Bool = false
    var indexPath: IndexPath?
    var deleteODF = false
    var itemForDelete = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        tableView.register(HistoryCell.nib(), forCellReuseIdentifier: HistoryCell.identifier())
        
        setShadowView(view: searchView)
        searchTextField.delegate = self
        isEnableHideKeyBoardWhenTouchInScreen = true
        pageLabel.setDefaultTitleField()
        
        isLoading = true
        tableView.keyboardDismissMode = .onDrag
        navigationBarButtonItems([(.back, .left)])
        setupLongPressGesture()
        deleteView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = "Lịch sử mời khách"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isLoading {
            isLoading = false
            self.showLoading()
            DispatchQueue.main.async {
                self.getAll()
                self.suggestKhachMoi = self.totalKhach
                self.countDisplay = self.suggestKhachMoi.count
                self.tableView.reloadData()
                self.hideLoading()
            }
        }
    }
    
    func setupLongPressGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(HomeViewController.handleLongPress))
        longPress.minimumPressDuration = 0.75
        longPress.delegate = self
        tableView.addGestureRecognizer(longPress)
    }
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                self.indexPath = indexPath
                tableView.deselectRow(at: indexPath, animated: true)
                print("Dang an o day", indexPath.row)
                deleteView.isHidden = false
                deleteODF = true
                let data = suggestKhachMoi[indexPath.row]
                try! realm.write {
                    data.isDelete = true
                }
                
                displayItemSelectLabel.text = "Đã chọn: 1/\(countDisplay)"
                if countDisplay == 1 {
                    selectAllItemImageView.image = #imageLiteral(resourceName: "icons8-checked_checkbox")
                    isSelectAllItem = true
                }
                itemForDelete += 1
                tableView.reloadData()
            }
        }
    }
    
    override func openMenu(_ sender: UIBarButtonItem) {
        print("open menu")
        cancelDelete()
        if let slideMenuController = self.slideMenuController() {
            slideMenuController.openLeft()
        }
    }
    
    override func back(_ sender: UIBarButtonItem) {
        backVC(controller: Storyboard.MainSlide.mainSlideMenuViewController())
    }
    
    func cancelDelete() {
        deleteView.isHidden = true
        deleteODF = false
        for item in suggestKhachMoi {
            let data = item
            try! realm.write {
                data.isDelete = false
            }
        }
        selectAllItemImageView.image = #imageLiteral(resourceName: "icons8-unchecked_checkbox")
        itemForDelete = 0
        tableView.reloadData()
    }
    
    func getAll() {
        let results = realm.objects(ThongTinKhachMoiModel.self).sorted(byKeyPath: "ten", ascending: true).toArray(ofType: ThongTinKhachMoiModel.self)
        print(results.count)
        totalKhach.removeAll()
        listHetNo.removeAll()
        listConNo.removeAll()
        for item in results {
            totalKhach.append(item)
            if let tienDiMung = item.giftMoney?.toInt(), let tienNhan = item.moneyReceived?.toInt() {
                if tienDiMung != 0, tienNhan != 0, tienDiMung - tienNhan == 0 {
                    listHetNo.append(item)
                } else {
                    listConNo.append(item)
                }
            }
        }
    }
    
    func filterKhachMoi() {
        switch loaiKhach {
        case .da_moi: //het no
            if searchTextField.text == "" {
                suggestKhachMoi = listHetNo
            } else {
                getResultFilter(array: listHetNo)
            }
        case .chua_moi: //con no
            if searchTextField.text == "" {
                suggestKhachMoi = listConNo
            } else {
                getResultFilter(array: listConNo)
            }
        case .tat_ca:
            if searchTextField.text == "" {
                suggestKhachMoi = totalKhach
            } else {
                getResultFilter(array: totalKhach)
            }
        }
        countDisplay = suggestKhachMoi.count
        tableView.reloadData()
    }
    
    func getResultFilter(array: [ThongTinKhachMoiModel]) {
        guard let text = searchTextField.text?.lowercased() else {
            return
        }
        suggestKhachMoi = array.filter { (data: ThongTinKhachMoiModel) in
            if let name = data.ten?.lowercased(), let address = data.dia_chi?.lowercased(), let phone = data.phone?.lowercased() {
                if name.range(of: text) != nil || address.range(of: text) != nil || phone.range(of: text) != nil {
                    return true
                }
                
            }
            return false
        }
        countDisplay = suggestKhachMoi.count
    }
    
    @IBAction func tapSegmentedControl(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            loaiKhach = .tat_ca
        case 1:
            loaiKhach = .chua_moi
        case 2:
            loaiKhach = .da_moi
        default:
            break
        }
        print("da chon \(loaiKhach)")
        getAll()
        filterKhachMoi()
        countDisplay = suggestKhachMoi.count
    }
    
    @IBAction func tapSelectAll(_ sender: Any) {
        isSelectAllItem = !isSelectAllItem
        if isSelectAllItem {
            for item in suggestKhachMoi {
                let data = item
                try! realm.write {
                    data.isDelete = true
                }
            }
            selectAllItemImageView.image = #imageLiteral(resourceName: "icons8-checked_checkbox")
            itemForDelete = countDisplay
        } else {
            for item in suggestKhachMoi {
                let data = item
                try! realm.write {
                    data.isDelete = false
                }
            }
            selectAllItemImageView.image = #imageLiteral(resourceName: "icons8-unchecked_checkbox")
            itemForDelete = 0
        }
        displayItemSelectLabel.text = "Đã chọn: \(itemForDelete)/\(countDisplay)"
        tableView.reloadData()
    }
    
    @IBAction func tapDelete(_ sender: Any) {
        if itemForDelete > 0 {
            showAlertWithConfirm(type: .notice, message: "Bạn chắc chắn muốn xoá", cancel: {
                
            }, ok: {
                self.deleteData()
            })
        } else {
            showAlertViewController(type: .error, message: "Chưa có mục nào để xoá", close: {
                
            })
        }
        
    }
    
    func deleteData() {
        for item in suggestKhachMoi {
            if item.isDelete {
                do {
                    try realm.write {
                        realm.delete(item)
                    }
                } catch {
                    print("Lỗi Delete đối tượng")
                }
            }
        }
        deleteODF = false
        isSelectAllItem = false
        selectAllItemImageView.image = #imageLiteral(resourceName: "icons8-unchecked_checkbox")
        displayItemSelectLabel.text = "Đã chọn:"
        deleteView.isHidden = true
        itemForDelete = 0
        
        getAll()
        filterKhachMoi()
    }
    
    @IBAction func tapCancel(_ sender: Any) {
        cancelDelete()
    }
    
}

extension HistoryVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestKhachMoi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.identifier(), for: indexPath) as! HistoryCell
        cell.setDisplay()
        cell.infoKM = suggestKhachMoi[indexPath.row]
        cell.checkSelect(index: indexPath, isDelete: deleteODF)
        cell.fillData()
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if deleteODF {
            let data = suggestKhachMoi[indexPath.row]
            try! realm.write {
                data.isDelete = !data.isDelete
                if data.isDelete {
                    itemForDelete += 1
                } else {
                    itemForDelete -= 1
                }
            }
            if itemForDelete == countDisplay {
                isSelectAllItem = true
                selectAllItemImageView.image = #imageLiteral(resourceName: "icons8-checked_checkbox")
            } else {
                isSelectAllItem = false
                selectAllItemImageView.image = #imageLiteral(resourceName: "icons8-unchecked_checkbox")
            }
            displayItemSelectLabel.text = "Đã chọn: \(itemForDelete)/\(countDisplay)"
            tableView.reloadData()
        } else {
            let vc = Storyboard.Main.chiTietGhiNoVC()
            vc.detailKM = suggestKhachMoi[indexPath.row]
            title = ""
            //        let vc = Storyboard.Main.detailHistoryVC()
            //        vc.infoKM = suggestKhachMoi[indexPath.row]
            vc.closureUpdateHistory = { [weak self] user in
                self?.suggestKhachMoi[indexPath.row] = user
                
                let realm = try! Realm()
                //                let offers = realm.... look up your objects
                let offers = realm.objects(ThongTinKhachMoiModel.self)
                realm.beginWrite()
                for offer in offers {
                    if offer.id == user.id {
                        offer.ten = user.ten
                        offer.tuoi = user.tuoi
                        offer.dia_chi = user.dia_chi
                        offer.quan_he = user.quan_he
                        
                        offer.phone = user.phone
                        offer.status = user.status
                        offer.longitude = user.longitude
                        offer.latitude = user.latitude
                        offer.note = user.note
                        
                        offer.giftMoney = user.giftMoney
                        offer.moneyReceived = user.moneyReceived
                    }
                }
                try! realm.commitWrite()
                self?.getAll()
                self?.filterKhachMoi()
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                let book = suggestKhachMoi[indexPath.row]
                // realm
                let realm = try Realm()
                
                // edit book
                try realm.write {
                    realm.delete(book)
                    //                    suggestKhachMoi.remove(at: indexPath.row)
                    getAll()
                    filterKhachMoi()
                }
            } catch {
                print("Lỗi Delete đối tượng")
            }
        }
    }
}

//MARK: UITextField Delegate
extension HistoryVC {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        filterKhachMoi()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
