//
//  HomeViewController.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/15/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

enum LoaiKhach {
    case chua_moi //tuong duong con no man lich su
    case da_moi //tuong duong het no man lich su
    case tat_ca
}

class HomeViewController: BaseViewController, UITextFieldDelegate {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var displayItemSelectLabel: UILabel!
    @IBOutlet weak var selectAllItemImageView: UIImageView!
    
    let realm = try! Realm()
    var totalKhach = [ThongTinKhachMoiModel]()
    var listKM = [ThongTinKhachMoiModel]()
    var listKCM = [ThongTinKhachMoiModel]()
    var suggestKhachMoi = [ThongTinKhachMoiModel]()
    var countDisplay: Int = 0 {
        didSet {
            pageLabel.text = "\(countDisplay)"
        }
    }
    var loaiKhach = LoaiKhach.tat_ca
    var isSelectAllItem: Bool = false
    var indexPath: IndexPath?
    var deleteODF = false
    var itemForDelete = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        navigationController?.navigationBar.isHidden = false
        
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(addTapped))
        
        //        let bar = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-menu"), style: .plain, target: self, action: #selector(openMenu))
        //        navigationItem.leftBarButtonItem = bar
        self.navigationBarButtonItems([(ItemType.leftMenu, ItemPosition.left)])
        
        isEnableHideKeyBoardWhenTouchInScreen = true
        registerCell()
        segmentedControl.selectedSegmentIndex = 0
        
        setShadowView(view: searchView)
        searchTextField.delegate = self
        setShadowButton(button: addButton, cornerRadius: 25)
        
        tableView.keyboardDismissMode = .onDrag
        pageLabel.text = ""
        isLoading = true
        setupLongPressGesture()
        deleteView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = "Minh Dương ❦ Phương Huyền"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if isLoading {
            isLoading = false
            self.showLoading()
            DispatchQueue.main.async {
                self.getAll()
                self.filterKhachMoi()
                self.tableView.reloadData()
                self.hideLoading()
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
                addButton.isHidden = true
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
    
    func getAll() {
        let results = realm.objects(ThongTinKhachMoiModel.self).sorted(byKeyPath: "name", ascending: true).toArray(ofType: ThongTinKhachMoiModel.self)
        print(results.count)
        totalKhach = results
        
        var tempChuaMoi = [ThongTinKhachMoiModel]()
        var tempDaMoi = [ThongTinKhachMoiModel]()
        
        for item in results {
            if item.status {
                tempDaMoi.append(item)
            } else {
                tempChuaMoi.append(item)
            }
        }
        listKM = tempDaMoi
        listKCM = tempChuaMoi
    }
    
    func filterKhachMoi() {
        switch loaiKhach {
        case .da_moi:
            if searchTextField.text == "" {
                suggestKhachMoi = listKM
            } else {
                getResultFilter(array: listKM)
            }
        case .chua_moi:
            if searchTextField.text == "" {
                suggestKhachMoi = listKCM
            } else {
                getResultFilter(array: listKCM)
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
            if let name = data.name?.lowercased(), let address = data.address?.lowercased(), let phone = data.phone?.lowercased() {
                if name.range(of: text) != nil || address.range(of: text) != nil || phone.range(of: text) != nil {
                    return true
                }
                
            }
            return false
        }
        countDisplay = suggestKhachMoi.count
    }
    
    func registerCell() {
        tableView.register(KhachMoiCell.nib(), forCellReuseIdentifier: KhachMoiCell.identifier())
    }
    
    //    @objc func addTapped() {
    //        let vc = storyboard?.instantiateViewController(identifier: "LeftViewController") as! LeftViewController
    //        vc.modalPresentationStyle = .overFullScreen
    //        vc.modalTransitionStyle = .crossDissolve
    //        vc.closureMenu = { [weak self] data in
    //            self?.selectActionMenu(data)
    //        }
    //        present(vc, animated: true, completion: nil)
    //    }
    
    
    func selectActionMenu(_ action: ActionMainMenuView) {
        switch action {
        case .len_danh_sach_khach_moi:
            isLoading = true
            let vc = Storyboard.Main.themKhachMoiVC()
            vc.totalItem = totalKhach.count
            vc.titleString = "Thêm khách mời"
            navigationController?.pushViewController(vc, animated: true)
        case .tutorial:
            //            sideMenuView.showHideMenu()
            let vc = Storyboard.TutorialStoryboard.tutorialVC()
            navigationController?.pushViewController(vc, animated: true)
        case .showImage:
            //            sideMenuView.showHideMenu()
            let vc = Storyboard.Main.weddingPhotoListVC()
            navigationController?.pushViewController(vc, animated: true)
        case .lich_su_moi_khach:
            isLoading = true
            let vc = Storyboard.Main.historyVC()
            navigationController?.pushViewController(vc, animated: true)
            //        case .change_avatar:
            //            title = "Minh Dương ❦ Phương Huyền"
        //           // tapSelectImage()
        case .logout:
            navigationController?.popViewController(animated: true)
        case .setting:
            let vc = Storyboard.Main.settingViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
        title = ""
    }
    
    //MARK: Action
    
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
        addButton.isHidden = false
        itemForDelete = 0
        
        getAll()
        filterKhachMoi()
    }
    
    @IBAction func tapCancel(_ sender: Any) {
        cancelDelete()
    }
    
    func cancelDelete() {
        deleteView.isHidden = true
        deleteODF = false
        addButton.isHidden = false
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
    
    @IBAction func tapSegmentControl(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            loaiKhach = .tat_ca
        case 1:
            loaiKhach = .da_moi
        case 2:
            loaiKhach = .chua_moi
        default:
            break
        }
        getAll()
        filterKhachMoi()
        countDisplay = suggestKhachMoi.count
    }
    
    //them khach moi
    @IBAction func tapNextAdd(_ sender: Any) {
        isLoading = true
        let vc = Storyboard.Main.themKhachMoiVC()
        title = ""
        vc.totalItem = totalKhach.count
        vc.titleString = "Thêm khách mời"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: TextField Delegate
    func textFieldDidChangeSelection(_ textField: UITextField) {
        filterKhachMoi()
        if deleteODF {
            isSelectAllItem = false
            for item in suggestKhachMoi {
                try! realm.write {
                    item.isDelete = false
                }
            }
            displayItemSelectLabel.text = "Đã chọn: 0/\(countDisplay)"
            selectAllItemImageView.image = #imageLiteral(resourceName: "icons8-unchecked_checkbox")
            itemForDelete = 0
            tableView.reloadData()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestKhachMoi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KhachMoiCell.identifier(), for: indexPath) as! KhachMoiCell
        cell.backgroundColor = .clear
        cell.infoKhachMoi = suggestKhachMoi[indexPath.row]
        cell.checkSelect(index: indexPath, isDelete: deleteODF)
        cell.fillData()
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
            let vc = Storyboard.Main.guestDetailsVC()
            
            vc.detailKhach = suggestKhachMoi[indexPath.row]
            title = ""
            vc.title = "Thông tin chi tiết"
            vc.closureUpdate = { [weak self] user in
                self?.suggestKhachMoi[indexPath.row] = user
                
                let realm = try! Realm()
                //                let offers = realm.... look up your objects
                let offers = realm.objects(ThongTinKhachMoiModel.self)
                realm.beginWrite()
                for offer in offers {
                    if offer.id == user.id {
                        offer.name = user.name
                        offer.age = user.age
                        offer.address = user.address
                        offer.relation = user.relation
                        
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
                // edit
                try realm.write {
                    realm.delete(book)
                    getAll()
                    filterKhachMoi()
                }
            } catch {
                print("Lỗi Delete đối tượng")
            }
        }
    }
}
