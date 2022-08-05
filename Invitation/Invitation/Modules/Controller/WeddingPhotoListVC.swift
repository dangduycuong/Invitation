//
//  WeddingPhotoListVC.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/4/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit
import RealmSwift

struct DataImage {
    var image: UIImage
    var path: String
}

class WeddingPhotoListVC: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewModeTextField: UITextField!
    
    let realm = try! Realm()
    var listDataImage = [DataImage]()
    let imagePicker =  UIImagePickerController()
    
    let WIDTH_SCREEN = UIScreen.main.bounds.width
    var numberOfItems: CGFloat = 4
    let padding: CGFloat = 1
    var width: CGFloat = 1
    let dropdown = DropDown()
    var sizeOfItem = CGSize(width: 92, height: 92)
    var listPath = [ImagePathModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(WeddingImageCell.nib(), forCellWithReuseIdentifier: WeddingImageCell.identifier())
        viewModeTextField.delegate = self
        imagePicker.delegate = self
        navigationController?.navigationBar.isHidden = false
        title = "Bộ sưu tập"
        navigationBarButtonItems([(ItemType.back, ItemPosition.left)])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showLoading()
        DispatchQueue.main.async {
            self.loadImage()
            self.hideLoading()
        }
    }
    
    override func back(_ sender: UIBarButtonItem) {
        backVC(controller: Storyboard.MainSlide.mainSlideMenuViewController())
    }
    
    func loadImage() {
        let results = realm.objects(ImagePathModel.self).toArray(ofType: ImagePathModel.self)
        listPath = results
        for item in results {
            if let path = item.path {
                if let image = getSavedImage(named: path) {
                    listDataImage.append(DataImage(image: image, path: path))
                }
            }
        }
        collectionView.reloadData()
//        if let count = UserDefaults.standard.string(forKey: "count")?.toInt() {
//            for item in 0...count {
//                if let image = getSavedImage(named: "fileName\(item)") {
//                    listDataImage.append(DataImage(image: image, path: "fileName\(item).png"))
//                }
//            }
//            collectionView.reloadData()
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listDataImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeddingImageCell.identifier(), for: indexPath) as! WeddingImageCell
        cell.imageView.image = listDataImage[indexPath.row].image
        cell.sizeOfItem = sizeOfItem
        cell.setDisplay()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showAlertWithConfirm(type: .notice, message: "Bạn có muốn xóa ảnh này", cancel: {
            
        }, ok: {
            self.deleteImage(indexPath: indexPath)
        })
        
    }
    
    func deleteImage(indexPath: IndexPath) {
        let fileManager = FileManager.default
        let named = listDataImage[indexPath.row].path
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            let contentsOfFile = URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path
            do {
                try fileManager.removeItem(atPath: contentsOfFile)
                self.listDataImage.remove(at: indexPath.row)
                collectionView.deleteItems(at: [indexPath])
                print("Xoá file thành công!")
                
                do {
                    let book = listPath[indexPath.row]
                    // realm
                    let realm = try Realm()
                    
                    // edit book
                    try realm.write {
                        realm.delete(book)
//                        getAll()
//                        filterKhachMoi()
                        listPath.remove(at: indexPath.row)
                    }
                } catch {
                    print("Lỗi Delete đối tượng")
                }
                
                collectionView.reloadData()
            } catch _ as NSError {
                print("Xoá file thất bại")
            }
        }
    }
    
    //MARK: Action
    //TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = "Chế độ xem"
        textField.resignFirstResponder()
        dropdown.dataSource = ["Xem dạng lưới", "Xem danh sách"]
        dropdown.anchorView = textField
        dropdown.direction = .bottom
        dropdown.bottomOffset = CGPoint(x: 0, y: textField.bounds.size.height)
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            textField.text = item
            self.numberOfItems = index == 1 ? 1 : 4
            let itemSize = (self.WIDTH_SCREEN - self.padding * 2 - self.padding * (self.numberOfItems - 1))/self.numberOfItems
            self.sizeOfItem = CGSize(width: itemSize, height: itemSize)
            self.collectionView.reloadData()
        }
        
        dropdown.show()
    }
    
    @IBAction func tapSelectImage(_ sender: UIButton) {
        sender.setTitleColor(UIColor.white, for: .normal)
        sender.isUserInteractionEnabled = true
        
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
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
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
            
            if saveImage(image: pickedImage) {
                collectionView.reloadData()
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
            let random = String.random()
            let count = listDataImage.count
//            try data.write(to: directory.appendingPathComponent("fileName\(count).png")!)
//            listDataImage.append(DataImage(image: image, path: "fileName\(count).png"))
//            let path = "fl\(count)\(random).png"
            let file = "hhihihi.png"
            print("path file", directory .absoluteString)
            try data.write(to: directory.appendingPathComponent(file)!)
            listDataImage.append(DataImage(image: image, path: file))
            let data = ImagePathModel()
            data.path = file
            try! realm.write {
                realm.add(data)
            }
            listPath.append(data)
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

extension WeddingPhotoListVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (WIDTH_SCREEN - padding * 2 - padding * (numberOfItems - 1))/numberOfItems
        sizeOfItem = CGSize(width: itemSize, height: itemSize)
        return CGSize(width: itemSize, height: itemSize)
    }
    
    // Spacing Between Each Edge Of Section
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: 0, bottom: padding, right: 0)
    }
    
    // Spacing Between Rows Of Section
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    
    //    Spacing Between Colums Of Section
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
}
