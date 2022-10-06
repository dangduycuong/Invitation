//
//  DirectVC.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/9/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit
import WebKit

class DirectVC: BaseViewController, WKNavigationDelegate {
    @IBOutlet weak var webView: WKWebView!
    
    var latitude: String?
    var longitude: String?
    var address: String?
    var stringTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        
        loadAddress()
        navigationBarButtonItems([(ItemType.back, ItemPosition.left), (.rightReload, .right)])
    }
    
    override func reloadAction() {
        loadAddress()
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
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showLoading()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideLoading()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideLoading()
    }
    
    func loadAddress() {
        let latitude = self.latitude ?? ""
        let longitude = self.longitude ?? ""
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "www.google.com"
        urlComponents.path = "/maps/dir//\(latitude),\(longitude)/@\(latitude),\(longitude)z/data=!4m2!4m1!3e0"
        if let url = urlComponents.url {
            let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
            webView.load(request)
        }
    }
    
}
