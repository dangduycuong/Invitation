//
//  DirectVC.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/9/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit

class DirectVC: BaseViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    
    var latitude: String?
    var longitude: String?
    var address: String?
    var stringTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        
        loadAddress()
        if(stringTitle.isEmpty){
            self.title = "Invitation"
        } else {
            self.title = stringTitle
        }
        setRightBarButton()
    }
    
    func setRightBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(onClickedReload))
        
        let bar = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-reboot"), style: .plain, target: self, action: #selector(onClickedReload))
        navigationItem.rightBarButtonItem = bar
    }
    
    func getLocation(){
        self.showLoading()
        VLocation.sharedInstance.getCurrentLocation { (currentLocation) in
            self.hideLoading()
            if let location = currentLocation {
                self.latitude = String.init(describing: location.coordinate.latitude)
                self.longitude = String.init(describing: location.coordinate.longitude)
                print(self.latitude as Any, self.longitude as Any)
            } else {
                self.showAlertWithConfirm(type: .notice, message: "Không thể lấy được vị trí, thử lại?", cancel: {
                }, ok: {
                    self.getLocation()
                })
            }
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("webViewDidStartLoad")
        showLoading()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("webViewDidFinishLoad")
        hideLoading()
    }
    
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("didFailLoadWithError")
        hideLoading()
    }
    
    func loadAddress() {
        let latitude = self.latitude ?? ""
        let longitude = self.longitude ?? ""
        let url = """
        https://www.google.com/maps/dir//\(latitude),\(longitude)/@\(latitude),\(longitude)z/data=!4m2!4m1!3e0
        """
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.loadRequest(myRequest)
        print("Sucessfully")
    }
    
    
    @objc func onClickedReload(_ sender: Any) {
        loadAddress()
    }
    
    // MARK: Actions
    
}
