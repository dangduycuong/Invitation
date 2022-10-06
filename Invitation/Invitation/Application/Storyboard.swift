//
//  Storyboard.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 11/26/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit
struct Storyboard {
    
}

extension Storyboard {
    
    struct Main {
        static let manager = UIStoryboard(name: "Main", bundle: nil)
        
        static func loginVC() -> LoginVC {
            return manager.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        }
        
        static func homeBaseNavigationController() -> BaseNavigationController {
            return manager.instantiateViewController(withIdentifier: "HomeBaseNavigationController") as! BaseNavigationController
        }
        
        
        static func navigationWedding() -> BaseNavigationController {
            return manager.instantiateViewController(withIdentifier: "WeddingBaseNavigationController") as! BaseNavigationController
        }
        
        static func navigationHistory() -> BaseNavigationController {
            return manager.instantiateViewController(withIdentifier: "HistoryBaseNavigationController") as! BaseNavigationController
        }
        
        static func navigationSetting() -> BaseNavigationController {
            return manager.instantiateViewController(withIdentifier: "SettingBaseNavigationController") as! BaseNavigationController
        }
        
        
        
        static func navigationThemKhachMoi() -> BaseNavigationController {
            return manager.instantiateViewController(withIdentifier: "NavigationThemKhachMoiVC") as! BaseNavigationController
        }
        
        static func themKhachMoiVC() -> ThemKhachMoiVC {
            return manager.instantiateViewController(withIdentifier: "ThemKhachMoiVC") as! ThemKhachMoiVC
        }
        
        static func chonDiaDiemVC() -> ChonDiaDiemVC {
            return manager.instantiateViewController(withIdentifier: "ChonDiaDiemVC") as! ChonDiaDiemVC
        }
        
        static func phonebookVC() -> PhonebookVC {
            return manager.instantiateViewController(withIdentifier: "PhonebookVC") as! PhonebookVC
        }
        
        static func weddingPhotoListVC() -> WeddingPhotoListVC {
            return manager.instantiateViewController(withIdentifier: "WeddingPhotoListVC") as! WeddingPhotoListVC
        }
        
        static func historyVC() -> HistoryVC {
            return manager.instantiateViewController(withIdentifier: "HistoryVC") as! HistoryVC
        }
        
        static func popupEditTienMungVC() -> PopupEditTienMungVC {
            return manager.instantiateViewController(withIdentifier: "PopupEditTienMungVC") as! PopupEditTienMungVC
        }
        
        static func directVC() -> DirectVC {
            return manager.instantiateViewController(withIdentifier: "DirectVC") as! DirectVC
        }
        
        static func settingViewController() -> SettingViewController {
            return manager.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        }
        
        static func getPasswordVC() -> GetPasswordVC {
            return manager.instantiateViewController(withIdentifier: "GetPasswordVC") as! GetPasswordVC
        }
        
        static func homeViewController() -> HomeViewController {
            return manager.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        }
        
        static func chiTietGhiNoVC() -> ChiTietGhiNoVC {
            return manager.instantiateViewController(withIdentifier: "ChiTietGhiNoVC") as! ChiTietGhiNoVC
        }
    }
    
    struct TutorialStoryboard {
        static let manager = UIStoryboard(name: "TutorialStoryboard", bundle: nil)
        
        static func navigationTutorial() -> BaseNavigationController {
            return manager.instantiateViewController(withIdentifier: "TutorialBaseNavigationController") as! BaseNavigationController
        }
        
        static func tutorialVC() -> TutorialVC {
            return manager.instantiateViewController(withIdentifier: "TutorialVC") as! TutorialVC
        }
    }
    
    struct MainSlide {
        static let manager = UIStoryboard(name: "MainSlide", bundle: nil)
        static func mainSlideMenuViewController() -> MainSlideMenuViewController {
            return manager.instantiateViewController(withIdentifier: "MainSlideMenuViewController") as! MainSlideMenuViewController
        }
        static func leftMenuNavigationController() -> BaseNavigationController {
            return manager.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! BaseNavigationController
        }
    }

}
