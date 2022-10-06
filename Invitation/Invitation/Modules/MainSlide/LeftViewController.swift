//
//  LeftViewController.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/30/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit

struct DataMenuView {
    var isOpen: Bool?
    var action: ActionMainMenuView?
}

enum ActionMainMenuView {
    case showImage
    case len_danh_sach_khach_moi  
    case lich_su_moi_khach
    case setting
    case tutorial
    case logout
    
    static let all = [showImage, len_danh_sach_khach_moi, lich_su_moi_khach, setting, tutorial, logout]

    static let listIcon = ["anh cuoi", "len_danh_sach_khach_moi", "lich_su_moi_khach", "notice", "tutorial", "null"]
    
    var text: String {
        get {
            switch self {
            case .showImage:
                return "Ảnh cưới"
            case .len_danh_sach_khach_moi:
                return "Lên danh sách khách mời"
            case .lich_su_moi_khach:
                return "Lịch sử mời khách"
            case .setting:
                return "Cài đặt"
            case .tutorial:
                return "Hướng dẫn sử dụng"
            case .logout:
                return "Đăng xuất"
            }
        }
    }
}

class LeftViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var husbandLabel: UILabel!
    @IBOutlet weak var wifeLabel: UILabel!
    
    var closureMenu: ((ActionMainMenuView)->(Void))?
    let imagePicker =  UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(MenuLeftCell.nib(), forCellReuseIdentifier: MenuLeftCell.identifier())
        setShadowView(view: contentView)
        setDisplay()
        imagePicker.delegate = self
        if let image = getSavedImage(named: "fileNameavatar") {
            avatarImageView.image = image
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fillData()
    }
    
    func setDisplay() {
        navigationController?.navigationBar.isHidden = true
//        avatarImageView.layer.cornerRadius = 60
//        husbandLabel.font = UIFont(name: "Georgia-Bold", size: 17)
//        husbandLabel.textColor = .white
//        wifeLabel.font = UIFont(name: "Georgia-Bold", size: 17)
//        wifeLabel.textColor = .white
    }
    
    private func fillData() {
        if let wife = UserDefaults.standard.string(forKey: UserDefaultKey.wife.rawValue) {
            wifeLabel.text = wife
        }
        if let husband = UserDefaults.standard.string(forKey: UserDefaultKey.husband.rawValue) {
            husbandLabel.text = husband
        }
    }
    
    override func setShadowView(view: UIView) {
        view.layer.cornerRadius = 0
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ActionMainMenuView.all.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuLeftCell.identifier(), for: indexPath) as! MenuLeftCell
        cell.titleMenuTextView.text = ActionMainMenuView.all[indexPath.row].text
        cell.iconImageView.image = UIImage(named: ActionMainMenuView.listIcon[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
        let menu = ActionMainMenuView.all[indexPath.row]
        selectActionMenu(menu)
    }
    
    func logout(){
        DispatchQueue.main.async {
            let signInViewController = Storyboard.Main.loginVC()
            //            UIApplication.shared.keyWindow?.rootViewController = signInViewController}
            
            let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            
            keyWindow?.rootViewController = signInViewController
            keyWindow?.endEditing(true) //co cung thay chay ma bo di cung chay
        }
    }
    
    func selectActionMenu(_ action: ActionMainMenuView) {
        var controller: UIViewController?
        controller = Storyboard.Main.weddingPhotoListVC()
        switch action {
        case .showImage:
            controller = Storyboard.Main.navigationWedding()
        case .len_danh_sach_khach_moi:
            controller = Storyboard.Main.navigationThemKhachMoi()
        case .lich_su_moi_khach:
            controller = Storyboard.Main.navigationHistory()
        case .setting:
            controller = Storyboard.Main.navigationSetting()
        case .tutorial:
            controller = Storyboard.TutorialStoryboard.navigationTutorial()
        case .logout:
            logout()
        }
        title = ""
        if let slideMenuController = self.slideMenuController(), let controller = controller {
            slideMenuController.changeMainViewController(controller, close: true)
        }
        
    }
    
    @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
        tapSelectImage()
    }
    
    @IBAction func tapDismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension LeftViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func tapSelectImage() {
        let alert = UIAlertController(title: "Chọn ảnh từ", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Máy ảnh", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Bộ sưu tập", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Hủy", style: .cancel, handler: nil))
        
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            //alert.popoverPresentationController?.sourceView = sender
            //alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            self.showAlertViewController(type: .warning, message: "Bạn không có camera", close: {})
            //            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            //            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            //            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary() {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK:-- ImagePicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            // imageViewPic.contentMode = .scaleToFill
            if saveImage(image: pickedImage) {
                
            }
            avatarImageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    //luu anh
    func saveImage(image: UIImage) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            //UserDefaults.standard.set(count, forKey: "count")
            try data.write(to: directory.appendingPathComponent("fileNameavatar.png")!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    //lay anh da luu
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
}
