//
//  Constant.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/3/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit

struct VTLocalizedString {
    static func localized(key: String) -> String {
        return "key.localizedString()"
    }

}

struct Constant {
    static let RES_SUCCESS_CODE_FROM_SV: Int = 0
    static let LIMIT_DISTANCE = (Preferences.shared().mnConfigDistance)
    static let SCREEN_WIDTH_PORTRAIT = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT_PORTRAIT = UIScreen.main.bounds.size.height
    static let NUMBER_RECORDS_PER_PAGE = 10
    
    //Huypn - add google map key
    //static let GOOGLE_MAP_API_KEY = "AIzaSyA0jdY93uyydIWg4Du6IE6dAfM-SWeTmQQ"
    static let GOOGLE_MAP_API_KEY = "AIzaSyC6a50plf6zJbvuBcmzBpRd3CQp4BRy1yI"
    
}


struct WS_CODE {
    static let LIST_DEVICE_TYPE = "LIST_DEVICE_TYPE"
    static let REASON_FAILURE_REPAIR_BY_DEVICE_TYPE = "REASON_FAILURE_REPAIR_BY_DEVICE_TYPE"
    static let LIST_DEVICE_REPAIR = "LIST_DEVICE_REPAIR"
}

extension Constant {
    
    // MARK: - App Delegate
    static func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    static let SCALE_W = UIScreen.main.bounds.width / 375
    
    // MARK: - Notification Key
    struct notificationKey {
        static let DID_UPDATE_STATION_NOTIFICATION_KEY: String = "DID_UPDATE_STATION_NOTIFICATION_KEY"
    }

    // MARK: - View
    struct view {
        static var window: UIView {
            get {
                return UIApplication.shared.keyWindow!
            }
        }
    }
    
    // MARK: - App Information
    struct appInformation {
        static var version: String {
            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                return version
            }
            
            return "alpha"
        }
    }
    
    // MARK: - Colors
    struct color {
        static var blueVSmart: UIColor {
            return UIColor.colorWithHexString("#0488D1")
        }
        
        static var backgroundVSmart: UIColor {
            return UIColor.colorWithHexString("#f9f9f9")
        }
        
        static var textVSmart: UIColor {
            return UIColor.colorWithHexString("#757575")
        }
        
        static var textColorVSmart: UIColor {
            return UIColor.colorWithHexString("#000000")
        }
        
        static var greenVSmart: UIColor
        {
            return UIColor.colorWithHexString("#49A28C")
        }
        
        //Huypn add status color
        static var colorXanh: UIColor
        {
            return UIColor.colorWithHexString("#00a58d")
        }
        
        static var colorDo: UIColor
        {
            return UIColor.colorWithHexString("#e2473b")
        }
        
        static var colorCam: UIColor
        {
            return UIColor.colorWithHexString("#ff9500")
        }
       
        static var colorXanhla: UIColor
        {
            return UIColor.colorWithHexString("#00a58d")
        }
        
        static var colorXam: UIColor
        {
            return UIColor.colorWithHexString("#8d8d8d")
        }
    }
    
    // MARK: - Format Date
    struct formatDate {
        static var shortNormalFormat: String{
            return "dd/MM/yyyy"
        }
        static let fulNormalFormat: String = "dd/MM/yyyy HH:mm:ss" //"yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        static let standardFormat : String = "dd/MM/yyyy HH:mm"
        static let fulHourFormat: String = "HH:mm:ss"
        static let fullFormatResp: String = "yyyy/MM/dd HH:mm:ss"
        static let fullSQLFormat: String = "yyyy-MM-dd HH:mm:ss"
        static var monthYearFormat: String{
            return "MM/yyyy"
        }
    }
    
    // MARK: - Fonts
    struct font {
        static func robotoBlack(ofSize fontSize: CGFloat) -> UIFont {
            guard let font = UIFont(name: "Roboto-Black", size: fontSize) else {
                return UIFont.systemFont(ofSize: fontSize)
            }
            
            return font
        }
        
        static func robotoBlackItalic(ofSize fontSize: CGFloat) -> UIFont {
            guard let font = UIFont(name: "Roboto-BlackItalic", size: fontSize) else {
                return UIFont.systemFont(ofSize: fontSize)
            }
            
            return font
        }
        
        static func robotoBold(ofSize fontSize: CGFloat) -> UIFont {
            guard let font = UIFont(name: "Roboto-Bold", size: fontSize) else {
                return UIFont.systemFont(ofSize: fontSize)
            }
            
            return font
        }
        
        static func robotoBoldItalic(ofSize fontSize: CGFloat) -> UIFont {
            guard let font = UIFont(name: "Roboto-BoldItalic", size: fontSize) else {
                return UIFont.systemFont(ofSize: fontSize)
            }
            
            return font
        }
        
        static func robotoItalic(ofSize fontSize: CGFloat) -> UIFont {
            guard let font = UIFont(name: "Roboto-Italic", size: fontSize) else {
                return UIFont.systemFont(ofSize: fontSize)
            }
            
            return font
        }
        
        static func robotoLight(ofSize fontSize: CGFloat) -> UIFont {
            guard let font = UIFont(name: "Roboto-Light", size: fontSize) else {
                return UIFont.systemFont(ofSize: fontSize)
            }
            
            return font
        }
        
        static func robotoLightItalic(ofSize fontSize: CGFloat) -> UIFont {
            guard let font = UIFont(name: "Roboto-LightItalic", size: fontSize) else {
                return UIFont.systemFont(ofSize: fontSize)
            }
            
            return font
        }
        
        static func robotoMedium(ofSize fontSize: CGFloat) -> UIFont {
            guard let font = UIFont(name: "Roboto-Medium", size: fontSize) else {
                return UIFont.systemFont(ofSize: fontSize)
            }
            
            return font
        }
        
        static func robotoMediumItalic(ofSize fontSize: CGFloat) -> UIFont {
            guard let font = UIFont(name: "Roboto-MediumItalic", size: fontSize) else {
                return UIFont.systemFont(ofSize: fontSize)
            }
            
            return font
        }
        
        static func robotoRegular(ofSize fontSize: CGFloat) -> UIFont {
            guard let font = UIFont(name: "Roboto-Regular", size: fontSize) else {
                return UIFont.systemFont(ofSize: fontSize)
            }
            
            return font
        }
        
        static func robotoThin(ofSize fontSize: CGFloat) -> UIFont {
            guard let font = UIFont(name: "Roboto-Thin", size: fontSize) else {
                return UIFont.systemFont(ofSize: fontSize)
            }
            
            return font
        }
        
        static func robotoThinItalic(ofSize fontSize: CGFloat) -> UIFont {
            guard let font = UIFont(name: "Roboto-ThinItalic", size: fontSize) else {
                return UIFont.systemFont(ofSize: fontSize)
            }
            
            return font
        }
        
        static func robotoCondensedBold(ofSize fontSize: CGFloat) -> UIFont {
            guard let font = UIFont(name: "Roboto-CondensedBold", size: fontSize) else {
                return UIFont.systemFont(ofSize: fontSize)
            }
            
            return font
        }
        
        static func robotoCondensedBoldItalic(ofSize fontSize: CGFloat) -> UIFont {
            guard let font = UIFont(name: "Roboto-CondensedBoldItalic", size: fontSize) else {
                return UIFont.systemFont(ofSize: fontSize)
            }
            
            return font
        }
        
        static func robotoCondensedItalic(ofSize fontSize: CGFloat) -> UIFont {
            guard let font = UIFont(name: "Roboto-CondensedItalic", size: fontSize) else {
                return UIFont.systemFont(ofSize: fontSize)
            }
            
            return font
        }
        
        static func robotoCondensedLight(ofSize fontSize: CGFloat) -> UIFont {
            guard let font = UIFont(name: "Roboto-CondensedLight", size: fontSize) else {
                return UIFont.systemFont(ofSize: fontSize)
            }
            
            return font
        }
        
        static func robotoCondensedLightItalic(ofSize fontSize: CGFloat) -> UIFont {
            guard let font = UIFont(name: "Roboto-CondensedLightItalic", size: fontSize) else {
                return UIFont.systemFont(ofSize: fontSize)
            }
            
            return font
        }
        
        static func robotoCondensedRegular(ofSize fontSize: CGFloat) -> UIFont {
            guard let font = UIFont(name: "Roboto-CondensedRegular", size: fontSize) else {
                return UIFont.systemFont(ofSize: fontSize)
            }
            
            return font
        }
    }
    
    //Platform
    struct Platform {
        static let isSimulator: Bool = {
            var isSim = false
            #if arch(i386) || arch(x86_64)
                isSim = true
            #endif
            return isSim
        }()
    }
}

extension UIColor {
    
    static func colorWithHexString(_ hexString: String, alpha: CGFloat = 1) -> UIColor {
        let r, g, b: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
//            cuongdd comment warning
//            let hexColor = hexString.substring(from: start)
            let hexColor = hexString[start...]
            if hexColor.count == 6 {
//                cuongdd comment warning
//                let scanner = Scanner(string: hexColor)
                let scanner = Scanner(string: String(hexColor))
                var hexNumber: UInt32 = 0
                
                if scanner.scanHexInt32(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat((hexNumber & 0x0000ff) >> 0) / 255
                    
                    return UIColor(red: r, green: g, blue: b, alpha: alpha)
                }
            }
        }

        return UIColor.clear
    }
}
