//
//  GuestDetailsViewModel.swift
//  Invitation
//
//  Created by cuongdd on 06/10/2022.
//  Copyright © 2022 Dang Duy Cuong. All rights reserved.
//

import Foundation

class GuestDetailsViewModel {
    var newInfoCustomer = ThongTinKhachMoiModel()
    
    func setupData(customer: ThongTinKhachMoiModel) {
        newInfoCustomer.id = customer.id
        newInfoCustomer.name = customer.name
        newInfoCustomer.age = customer.age
        newInfoCustomer.address = customer.address
        newInfoCustomer.latitude = customer.latitude
        newInfoCustomer.longitude = customer.longitude
        newInfoCustomer.relation = customer.relation
        newInfoCustomer.giftMoney = customer.giftMoney
        newInfoCustomer.moneyReceived = customer.moneyReceived
        newInfoCustomer.phone = customer.phone
        newInfoCustomer.status = customer.status
        newInfoCustomer.note = customer.note
    }
    
    func updateAddressCustomer(customer: ThongTinKhachMoiModel) {
        newInfoCustomer.address = customer.address
        newInfoCustomer.latitude = customer.latitude
        newInfoCustomer.longitude = customer.longitude
    }
}
