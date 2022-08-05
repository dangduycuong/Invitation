//
//  Preferences.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/3/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit

typealias TupleStatus = (isApprove: Bool,isFromDetail: Bool,canAddboth: Bool)

class Preferences {
    
    // MARK: - Properties
    
    private static var sharedNetworkManager = Preferences()
    
    var totalCountArr = 0
    var totalAssetArr = 0
    var totalMerchandiseArr = 0
    var mnConfigDistance : String = "0"
    var limitNIMS : String = ""
    var objArray:[Any] = []
    var typeSelectTab = 0
    var isFromSuggestHour: Bool = false
    var isFromAddWarning: Bool = false
    

    var mapId: Int?
    var userLoginUnit: Int = 0
    var userLogin : Int = 0
    
    var dataStormInfo = Dictionary<String,Any?>()
    var stationCode = ""
    
    private init() {}

    // MARK: - Accessors
    
    class func shared() -> Preferences {
        return sharedNetworkManager
    }
//    cuongdd comment
//    var isAutoGetLocationUCBL: Bool {
//        set {
//            let value = NSKeyedArchiver.archivedData(withRootObject: newValue)
//            UserDefaults.standard.set(value, forKey: "isAutoGetLocationUCBL")
//        }
//
//        get {
//            if UserDefaults.standard.object(forKey: "isAutoGetLocationUCBL") != nil {
//                let data = UserDefaults.standard.object(forKey: "isAutoGetLocationUCBL")
//                if let data = data as? Data {
//                    if let value = NSKeyedUnarchiver.unarchiveObject(with: data) as? Bool {
//                        return value
//                    }
//                }
//            }
//
//            return false
//        }
//    }
    
}
