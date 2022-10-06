//
//  LoginVC.swift
//  Invitation
//
//  Created by Boss on 12/23/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit

enum SeclectAvatarLogin {
    case topAvatar
    case formLogin
}

class LoginVC: BaseViewController, UITextFieldDelegate {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var avatarLoginImageView: UIImageView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var showPasswordButton: UIButton!
    
    @IBOutlet weak var bottomLineUserView: UIView!
    @IBOutlet weak var bottomLinePasswordView: UIView!
    
    @IBOutlet weak var heightLineUserView: NSLayoutConstraint!
    
    @IBOutlet weak var heightLinePasswordView: NSLayoutConstraint!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var showPasswordImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var saveUserLoginImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var formImageView: UIImageView!
    
    var choosImage = SeclectAvatarLogin.topAvatar
    let imagePicker =  UIImagePickerController()
    
    var isSaveUser: Bool = true
    
    var isHidenShowPassword: Bool = true {
        didSet {
            showPasswordButton.isHidden = isHidenShowPassword
//            showPasswordImageView.isHidden = isHidenShowPassword
        }
    }
    var isShowPassword: Bool = false
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        setDisplay()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.tick) , userInfo: nil, repeats: true)
        setFirstRunApp()
        
        setupNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserDefaults.standard.set(false, forKey: UserDefaultKey.isLogin.rawValue)
        super.viewWillAppear(animated)
        if isSaveUser == false {
            passwordTextField.text = ""
        }
        navigationController?.navigationBar.isHidden = true
        if let wife = UserDefaults.standard.string(forKey: UserDefaultKey.wife.rawValue), let husband = UserDefaults.standard.string(forKey: UserDefaultKey.husband.rawValue) {
            nameLabel.text = wife + " ❦ " + husband
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        formImageView.layer.cornerRadius = (formImageView.bounds.size.width / 2)
    }
    
    func setFirstRunApp() {
        if UserDefaults.standard.string(forKey: UserDefaultKey.usernameAuthentication.rawValue) == nil, UserDefaults.standard.string(forKey: UserDefaultKey.passwordAuthentication.rawValue) == nil {
            UserDefaults.standard.set("admin", forKey: UserDefaultKey.usernameAuthentication.rawValue)
            UserDefaults.standard.set("admin", forKey: UserDefaultKey.passwordAuthentication.rawValue)
        }
    }
    
    func setShadowLabel(label: UILabel) {
        label.layer.cornerRadius = 25
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.35
        label.layer.shadowOffset = .zero
        label.layer.shadowRadius = 10
    }
    
    func setupNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Thông báo quan trọng"
        content.body = "Ứng dụng cần được khởi chạy để đảm bảo dữ liệu toàn vẹn."
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 604800, repeats: true) //sau mot tuan bao mot lan
        let request = UNNotificationRequest(identifier: "TestIdentifier", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func setDelegate() {
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        imagePicker.delegate = self
    }
    
    func localToUTC(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone.current
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "H:mm:ss"
        
            return dateFormatter.string(from: date)
        }
        return nil
    }

    func utcToLocal(dateStr: String) -> String? {
        //2022-08-05 09:51:51 UTC
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    @objc func tick() {
        guard let isoDate = utcToLocal(dateStr: "2022-08-05 09:51:51") else {
            return
        }
//        let isoDate = "2022-08-05 17:30:00"
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: isoDate)!
        let cur = Date()
        
        currentTimeLabel.text = cur.offsetFrom(date: date)
        if cur.offsetFrom(date: date) == "" {
            currentTimeLabel.text = date.offsetFrom(date: cur)
        }
        
    }
    
    func setDisplay() {
        
        middleView.isHidden = true
        
        saveUserLoginImageView.image = UIImage(named: "icons8-unchecked_radio_button-1")
        if let username = UserDefaults.standard.string(forKey: UserDefaultKey.username.rawValue), let password = UserDefaults.standard.string(forKey: UserDefaultKey.password.rawValue) {
            usernameTextField.text = username
            passwordTextField.text = password
        }
        passwordTextField.isSecureTextEntry = true
        showPasswordImageView.image = #imageLiteral(resourceName: "icons8-hide-1")
        loginButton.setDefaultButton()
        isHidenShowPassword = passwordTextField.text == ""
        
        if let image = getSavedImage(named: "topAvatar") {
            avatarImageView.image = image
        }
        if let image = getSavedImage(named: "formLogin") {
            formImageView.image = image
        }
        setShadowLabel(label: currentTimeLabel)
    }
    
    func validateLogin() -> Bool {
        if usernameTextField.text == "" {
            showAlertViewController(type: .error, message: "Chưa nhập tên tài khoản. Vui lòng điền tên đăng nhập.", close: {
                
            })
            return false
        }
        if passwordTextField.text == "" {
            showAlertViewController(type: .error, message: "Chưa nhập mật khẩu. Vui lòng nhập mật khẩu.", close: {
                
            })
            return false
        }
        return true
    }
    
    func authenticateLogin() {
        if let username = usernameTextField.text, let password = passwordTextField.text, let userAuth = UserDefaults.standard.string(forKey: UserDefaultKey.usernameAuthentication.rawValue), let passwordAuth = UserDefaults.standard.string(forKey: UserDefaultKey.passwordAuthentication.rawValue) {
            if username == userAuth && password == passwordAuth {
                saveLocalUser()
                nextToMain()
//                let vc = Storyboard.Main.homeViewController()
//                navigationController?.pushViewController(vc, animated: true)
            } else {
                showAlertViewController(type: .error, message: "Sai tên đăng nhập hoặc mật khẩu. Vui lòng thử lại", close: {
                    
                })
            }
        }
    }
    
    func nextToMain() {
        UserDefaults.standard.set(true, forKey: UserDefaultKey.isLogin.rawValue)
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
    
    func saveLocalUser() {
        if let username = usernameTextField.text, let password = passwordTextField.text {
            if isSaveUser {
                UserDefaults.standard.set(username, forKey: UserDefaultKey.username.rawValue)
                UserDefaults.standard.set(password, forKey: UserDefaultKey.password.rawValue)
            } else {
                UserDefaults.standard.removeObject(forKey: UserDefaultKey.username.rawValue)
                UserDefaults.standard.removeObject(forKey: UserDefaultKey.password.rawValue)
            }
        }
    }
    
    // Delegate TextField
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case usernameTextField:
            topView.isHidden = true
            middleView.isHidden = false
            bottomLineUserView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0.5019607843, alpha: 1)
            bottomLinePasswordView.backgroundColor = .darkGray
//            heightLineUserView.constant = 1.5
//            heightLinePasswordView.constant = 0.5
        case passwordTextField:
            topView.isHidden = true
            middleView.isHidden = false
            isHidenShowPassword = passwordTextField.text == ""
            bottomLineUserView.backgroundColor = .darkGray
            bottomLinePasswordView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0.5019607843, alpha: 1)
//            heightLineUserView.constant = 0.5
//            heightLinePasswordView.constant = 1.5
        default:
            break
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case usernameTextField:
            break
        case passwordTextField:
            isHidenShowPassword = passwordTextField.text == ""
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
            tapLogin(self)
        default:
            break
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        bottomLineUserView.backgroundColor = .darkGray
        bottomLinePasswordView.backgroundColor = .darkGray
        heightLineUserView.constant = 0.5
        heightLinePasswordView.constant = 0.5
        topView.isHidden = false
        middleView.isHidden = true
    }
    
//    override func touchOnScreen() {
//        guard isEntering == false else {
//            return
//        }
//        topView.isHidden = false
//        middleView.isHidden = true
//        view.endEditing(true)
//    }
    
    // MARK: Action
    @IBAction func tapShowHidePassword(_ sender: Any) {
        isShowPassword = !isShowPassword
        if isShowPassword {
            passwordTextField.isSecureTextEntry = false
            showPasswordImageView.image = #imageLiteral(resourceName: "icons8-visible-1")
        } else {
            passwordTextField.isSecureTextEntry = true
            showPasswordImageView.image = #imageLiteral(resourceName: "icons8-hide-1")
        }
    }
    
    @IBAction func tapGetPassword(_ sender: Any) {
        let vc = Storyboard.Main.getPasswordVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    @IBAction func tapLogin(_ sender: Any) {
        usernameTextField.text = "admin"
        passwordTextField.text = "admin"
        if validateLogin() {
            authenticateLogin()
        }
    }
}

//MARK: Chon anh
extension LoginVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
            if choosImage == .topAvatar {
                avatarImageView.image = pickedImage
            } else {
                formImageView.image = pickedImage
            }
            
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
            var path = ""
            if choosImage == .topAvatar {
                path = "topAvatar"
            } else {
                path = "formLogin"
            }
            try data.write(to: directory.appendingPathComponent("\(path).png")!)
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
    
    @IBAction func handleGestureAvatar(_ sender: UIPanGestureRecognizer) {
        choosImage = .topAvatar
        tapSelectImage()
    }
    
    @IBAction func handleGestureFormLogin(_ sender: UIPanGestureRecognizer) {
        choosImage = .formLogin
        tapSelectImage()
    }
}

