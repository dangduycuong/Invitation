//
//  AppDelegate.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/3/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import UserNotifications
import IQKeyboardManagerSwift
import RealmSwift

//let googleApiKey = "AIzaSyC6a50plf6zJbvuBcmzBpRd3CQp4BRy1yI"
let googleApiKey = "AIzaSyBjK7ZifDuLbogjhWx9XjpIcRlczC6c-I0"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        let GOOGLE_MAP_API_KEY = "AIzaSyC6a50plf6zJbvuBcmzBpRd3CQp4BRy1yI" //key vsmart
        
        GMSServices.provideAPIKey(googleApiKey)
        GMSPlacesClient.provideAPIKey("AIzaSyANQclsIUV880B7njDUtqiL1IlbwR61lSM")
        //xin quyen local notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, err) in
            print("granted: \(granted)")
        }
        UNUserNotificationCenter.current().delegate = self
        
        configKeyboard()
        configRealmDB()
        
        return true
    }
    
    private func configRealmDB() {
//        let mySchemaVersion = 3
//        let config = Realm.Configuration(schemaVersion: UInt64(mySchemaVersion), migrationBlock: { migration, oldSchemaVersion in
//            if oldSchemaVersion < 4 {
//                migration.enumerateObjects(ofType: ThongTinKhachMoiModel.className()) { oldObject, newObject in
//                    // combine name fields into a single field
//                }
//                migration.renameProperty(onType: ThongTinKhachMoiModel.className(), from: "ten", to: "name")
//            }
//        })
//        Realm.Configuration.defaultConfiguration = config
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "TestIdentifier" {
            print("handling notifications with the TestIdentifier Identifier")
        }
        completionHandler()
    }
    
    func configKeyboard() {
        // Remove before app release.
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 80
    }
}

