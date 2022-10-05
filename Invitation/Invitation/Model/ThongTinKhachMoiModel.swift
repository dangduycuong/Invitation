//
//  ThongTinKhachMoiModel.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 11/26/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import RealmSwift
import UIKit

class ThongTinKhachMoiModel: Object {
    @objc dynamic var id: String?
    @objc dynamic var name: String?
    @objc dynamic var age: String?
    @objc dynamic var address: String?
    @objc dynamic var phone: String?
    @objc dynamic var relation: String?
    @objc dynamic var status: Bool = false

    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var moneyReceived: String?
    @objc dynamic var giftMoney: String?

    @objc dynamic var note: String?
    @objc dynamic var isDelete: Bool = false
    
//    @objc dynamic var id: String = ""
//    @objc dynamic var ten: String = ""
//    @objc dynamic var tuoi: String = ""
//    @objc dynamic var dia_chi: String = ""
//    @objc dynamic var phone: String = ""
//    @objc dynamic var quan_he: String = ""
//    @objc dynamic var status: Bool = false
//
//    @objc dynamic var latitude: Double = 0.0
//    @objc dynamic var longitude: Double = 0.0
//    @objc dynamic var moneyReceived: String = ""
//    @objc dynamic var giftMoney: String = ""
//
//    @objc dynamic var note: String = ""
//    @objc dynamic var isDelete: Bool = false
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

class ImagePathModel: Object {
    @objc dynamic var path: String?
    
    override class func primaryKey() -> String? {
        return "path"
    }
}
