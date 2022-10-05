//
//  LandingVC.swift
//  Invitation
//
//  Created by cuongdd on 05/10/2022.
//  Copyright © 2022 Dang Duy Cuong. All rights reserved.
//

import UIKit

class LandingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let isLogin = UserDefaults.standard.value(forKey: UserDefaultKey.isLogin.rawValue) as? Bool {
            if isLogin {
                gotoMainApp()
            } else {
                gotoLogin()
            }
        } else {
            gotoLogin()
        }
    }
    
    private func gotoMainApp() {
        let mainSlideMenuViewController = Storyboard.MainSlide.mainSlideMenuViewController()
        UIApplication.shared.keyWindow?.rootViewController = mainSlideMenuViewController
    }
    
    private func gotoLogin() {
        guard let vc = R.storyboard.main.loginVC() else {
            return
        }
        let baseNC = BaseNavigationController(rootViewController: vc)
        UIApplication.shared.keyWindow?.rootViewController = baseNC
    }

}
