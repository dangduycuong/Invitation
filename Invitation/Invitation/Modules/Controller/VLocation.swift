//
//  VLocation.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/10/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit
import MapKit

class VLocation: NSObject, CLLocationManagerDelegate {

    //Singleton
    class var sharedInstance: VLocation {
        struct Static {
            static let instance: VLocation = VLocation()
        }
        return Static.instance
    }
    var location = CLLocationManager()
    var currentLocation: CLLocation?
    var isRunningBG : Bool = false
    //fake
    //var currentLocation: CLLocation? // = CLLocation(latitude: 21.0179, longitude: 105.783)
    override init() {
        self.location = CLLocationManager()
        self.location.requestAlwaysAuthorization()
    }
    
    deinit {
        self.currentLocation = nil
    }
    //MARK: - GET CURRENT LOCATION
    public func getCurrentLocation(completion:@escaping (_ currentLocation: CLLocation?) ->Void){
        self.location = CLLocationManager()
        
        if CLLocationManager.locationServicesEnabled() {
            self.location.delegate = self
            self.location.requestAlwaysAuthorization()
//            self.location.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            if isRunningBG == true {
                self.location.allowsBackgroundLocationUpdates = true
                self.location.pausesLocationUpdatesAutomatically = false
            }
            self.location.startUpdatingLocation()
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                self.showGuideMessage()
//                self.location.requestAccess = .requestWhenInUseAuthorization
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                completion(self.currentLocation)
            }
        } else {
            self.showGuideMessage()
            print("Location services are not enabled")
        }
        
    }
    func showGuideMessage(){
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            let alertViewController = UIAlertController(title: VTLocalizedString.localized(key: "Thông báo"), message: "youNeedTurnOnGPS", preferredStyle: .alert)
        
            let okAction = UIAlertAction(title: VTLocalizedString.localized(key: "BUTTON_SETTINGS"), style: .default) { (alert) in
                if #available(iOS 10.0, *) {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        // If general location settings are disabled then open general location settings
                        UIApplication.shared.openURL(url)
                    }
                } else {
                    let url = URL(string : "prefs:root=")
                    if UIApplication.shared.canOpenURL(url!) {
                        UIApplication.shared.openURL(url!)
                    }
                }
            }
            let cancel = UIAlertAction(title: VTLocalizedString.localized(key: "Hủy bỏ"), style: .cancel) { (alert) in
                
            }
            
            alertViewController.addAction(okAction)
            alertViewController.addAction(cancel)
            topController.present(alertViewController, animated: true, completion: nil)
        }
    }
    // Print out the location to the console
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
//            print("ManhTT_Location: \(location.coordinate)")
            self.currentLocation = location
        }
    }
    
    //MARK: - DISTANCE BETTWEN 2 LOCATIONS
    //Calculate distance from 2 location
    func distanceBetweenTwoLocations(source:CLLocation, destination:CLLocation) -> Double{
        let distanceMeters = source.distance(from: destination)
        //var distanceKM = distanceMeters / 1000
        return distanceMeters
    }
}

