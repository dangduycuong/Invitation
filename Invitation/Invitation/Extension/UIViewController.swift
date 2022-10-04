//
//  UIViewController.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/30/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit

enum ItemPosition {
    case left, right
}

enum ItemType {
    case back, leftMenu, rightReload, rightCallSupport, rightViewInfo, rightUpdate, rightAdd, rightMenu, rightUpdateLocation
}

extension UIViewController {
    
    func navigationBarButtonItems(_ items: [(ItemType, ItemPosition)]?) {
        self.navigationItem.rightBarButtonItems = nil
        self.navigationItem.leftBarButtonItems = nil
        
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(back(_:)))
        self.navigationItem.backBarButtonItem = backButtonItem
        
        guard let items = items else {
            return
        }
        
        var rightBarButtonItems: [UIBarButtonItem] = [UIBarButtonItem]()
        var leftBarButtonItems: [UIBarButtonItem] = [UIBarButtonItem]()
        
        for (key, value) in items {
            var item: UIBarButtonItem?
            switch key {
            case .back:
                let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
                backButton.setImage(UIImage(named: "back-icon"), for: .normal)
                backButton.showsTouchWhenHighlighted = true
                backButton.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
                backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
                let backItem = UIBarButtonItem(customView: backButton)
                item = backItem
                
            case .leftMenu:
                let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
                menuButton.setImage(UIImage(named: "menu-icon"), for: .normal)
                menuButton.showsTouchWhenHighlighted = true
                menuButton.addTarget(self, action: #selector(openMenu(_:)), for: .touchUpInside)
                menuButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
                let menuItem = UIBarButtonItem(customView: menuButton)
                item = menuItem
                
            case .rightReload:
                let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 44))
                backButton.setImage(UIImage(named: "reload-icon"), for: .normal)
                backButton.showsTouchWhenHighlighted = true
                backButton.addTarget(self, action: #selector(reloadAction), for: .touchUpInside)
                backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
                let backItem = UIBarButtonItem(customView: backButton)
                item = backItem
                
            case .rightCallSupport:
                let callSupportButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 44))
                callSupportButton.setImage(UIImage(named: "call-support-icon"), for: .normal)
                callSupportButton.showsTouchWhenHighlighted = true
                callSupportButton.addTarget(self, action: #selector(callSupportAction), for: .touchUpInside)
                callSupportButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
                let callSupportItem = UIBarButtonItem(customView: callSupportButton)
                item = callSupportItem
                
            case .rightViewInfo:
                let viewInfoButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 44))
                viewInfoButton.setImage(UIImage(named: "view-info-icon"), for: .normal)
                viewInfoButton.showsTouchWhenHighlighted = true
                viewInfoButton.addTarget(self, action: #selector(viewInfoAction), for: .touchUpInside)
                viewInfoButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
                viewInfoButton.alpha = 0.3
                let viewInfoItem = UIBarButtonItem(customView: viewInfoButton)
                item = viewInfoItem
                
            case .rightUpdate:
                let rightSRWS = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 44))
                rightSRWS.setImage(UIImage(named: "icon_edit"), for: .normal)
                rightSRWS.addTarget(self, action: #selector(buttonBarUpdate), for: .touchUpInside)
                rightSRWS.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
                rightSRWS.alpha = 1
                let rightSRWSItem = UIBarButtonItem(customView: rightSRWS)
                item = rightSRWSItem
                
            case .rightAdd:
                let rightAddSRWS = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 44))
                rightAddSRWS.setImage(UIImage(named: "Whiteplus"), for: .normal)
                rightAddSRWS.addTarget(self, action: #selector(buttonBarToAdd), for: .touchUpInside)
                rightAddSRWS.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
                rightAddSRWS.alpha = 1
                let rightAddSRWSItem = UIBarButtonItem(customView: rightAddSRWS)
                item = rightAddSRWSItem
                
            //HungNM
            case .rightMenu:
                let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
                menuButton.setImage(UIImage(named: "menu-icon"), for: .normal)
                menuButton.showsTouchWhenHighlighted = true
                menuButton.addTarget(self, action: #selector(openRightMenu), for: .touchUpInside)
                menuButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
                let menuItem = UIBarButtonItem(customView: menuButton)
                item = menuItem
                
            case .rightUpdateLocation:
                let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
                menuButton.setImage(UIImage(named: "ic_update_location"), for: .normal)
                menuButton.showsTouchWhenHighlighted = true
                menuButton.addTarget(self, action: #selector(openRightUpdateLocation), for: .touchUpInside)
                menuButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
                let menuItem = UIBarButtonItem(customView: menuButton)
                item = menuItem
                
            }
            
            guard let guardItem = item else {
                continue
            }
            
            switch value {
            case .right:
                rightBarButtonItems.append(guardItem)
                
            case .left:
                leftBarButtonItems.append(guardItem)
            }
        }
        
        self.navigationItem.setRightBarButtonItems(rightBarButtonItems, animated: false)
        self.navigationItem.setLeftBarButtonItems(leftBarButtonItems, animated: false)
    }
    
    
    // MARK: - Actions
    @objc func back(_ sender: UIBarButtonItem) {
        if let viewcontroller = navigationController, viewcontroller.viewControllers.count > 1 {
            viewcontroller.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func openMenu(_ sender: UIBarButtonItem) {
        if let slideMenuController = self.slideMenuController() {
            slideMenuController.openLeft()
        }
    }
    
    @objc func openRightMenu() {
        
    }
    
    @objc func openRightUpdateLocation() {
        
    }
    
    @objc func callSupportButtonAction(_ sender: UIBarButtonItem) {
    }
    
    @objc func reloadAction() {
        
    }
    
    @objc func callSupportAction() {
        let version = "\n Version:" + String((Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String) ?? "")
        let alertController = UIAlertController(title:
            "callSupport", message: "call19001600" + version, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "CÓ", style: UIAlertAction.Style.default, handler:{(alertAction) in
            if let url = URL(string: "tel://\(1789)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "KHÔNG", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func viewInfoAction() {
//        KVLoading.show()
//        StationInOutManager.sharedInstance.autoDetectNotOutStation { (station: StationModel?) in
//            KVLoading.hide()
//            let stationInOutVC = Storyboard.stationInOut.stationInOutInfoViewController()
//            if station != nil {
//                stationInOutVC.notOutStation = station
//            }
//            self.navigationController?.pushViewController(stationInOutVC, animated: true)
//        }
    }
    
    @objc func buttonBarUpdate(){
        
    }
    
    @objc func buttonBarToAdd(){
        
    }
    
    @objc func showQuickAccessInOutStation(_ sender: UIBarButtonItem){
//        KVLoading.show()
//        StationInOutManager.sharedInstance.autoDetectNotOutStation { (station: StationModel?) in
//            KVLoading.hide()
//            var controller: BaseNavigationController?
//            if let model = station{
//                controller = Storyboard.stationInOut.stationNavigationController() as BaseNavigationController
//                let stationRootVC = controller?.viewControllers.first as! StationInOutInfoViewController
//                stationRootVC.notOutStation = model
//            } else {
//                controller = Storyboard.stationInOut.stationNavigationController() as BaseNavigationController
//            }
//            
//            if let slideMenuController = self.slideMenuController(), let controller = controller {
//                slideMenuController.changeMainViewController(controller, close: true)
//            }
//        }
    }
    
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        let paragraphStyle = NSMutableParagraphStyle()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: R.font.playfairDisplayBold(size: 17) as Any,
            .foregroundColor: UIColor.white,
            .paragraphStyle: paragraphStyle,
        ]
        appearance.titleTextAttributes = attributes
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
    }
    
}
