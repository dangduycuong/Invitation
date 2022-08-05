//
//  PopupEditTienMungVC.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/9/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit

class PopupEditTienMungVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var tienMungTextField: UITextField!
    @IBOutlet weak var valueChangeTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    
    var infoKM = ThongTinKhachMoiModel()
    var editDiMung: Bool = false
    var closureFinished: ((Int) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillData()
        valueChangeTextField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setShadowView()
    }
    
    func fillData() {
        if editDiMung {
            titleTextField.text = "Tiền đi mừng"
            tienMungTextField.text = infoKM.giftMoney?.toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
        } else {
            titleTextField.text = "Tiền khách mừng"
            tienMungTextField.text = infoKM.moneyReceived?.toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
        }
        
    }
    
    func setShadowView() {
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.8
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowRadius = 10
        
        cancelButton.roundCorners(corners: .bottomLeft, radius: 8)
        okButton.roundCorners(corners: .bottomRight, radius: 8)
        buttonView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 8)
    }
    
    @IBAction func tapAdd(_ sender: Any) {
//        if let tienMung = tienMungTextField.text?.toInt(), let value = valueChangeTextField.text?.toInt() {
//            let change = tienMung + value
//            tienMungTextField.text = change.toString()
//        }
        if let sourceText = tienMungTextField.text, let textChange = valueChangeTextField.text {
            let sourceValue = sourceText.replacingOccurrences(of: " ", with: "").toInt() ?? 0
            let valueChange = textChange.replacingOccurrences(of: " ", with: "").toInt() ?? 0
            let result = sourceValue + valueChange
            tienMungTextField.text = result.toString().toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
        }
    }
    
    @IBAction func tapMinus(_ sender: Any) {
        if let sourceText = tienMungTextField.text, let textChange = valueChangeTextField.text {
            let sourceValue = sourceText.replacingOccurrences(of: " ", with: "").toInt() ?? 0
            let valueChange = textChange.replacingOccurrences(of: " ", with: "").toInt() ?? 0
            let result = sourceValue - valueChange
            tienMungTextField.text = result.toString().toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
        }
    }
    
    @IBAction func tapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapDone(_ sender: Any) {
        if let text = tienMungTextField.text {
            let tien = text.replacingOccurrences(of: " ", with: "").toInt() ?? 0
            closureFinished?(tien)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard textField == valueChangeTextField else {
            return
        }
        if let text = valueChangeTextField.text {
            if text.hasPrefix("0") {
                valueChangeTextField.text = ""
            }
            let d = text.replacingOccurrences(of: " ", with: "")
            valueChangeTextField.text = d.toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case valueChangeTextField:
            if let text = valueChangeTextField.text {
                if text.hasPrefix("0") {
                    valueChangeTextField.text = ""
                }
                let d = valueChangeTextField.text?.replacingOccurrences(of: " ", with: "")
                valueChangeTextField.text = d?.toDouble()?.displayDecimal(groupingSeparator: " ", decimalSeparator: ",")
            }
        default:
            break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case valueChangeTextField:
            guard let text = valueChangeTextField.text,
                let rangeOfTextToReplace = Range(range, in: text) else {
                    return false
            }
            let substringToReplace = text[rangeOfTextToReplace]
            let count = text.count - substringToReplace.count + string.count
            return count <= 11
        default:
            break
        }
        return true
    }
    
}
