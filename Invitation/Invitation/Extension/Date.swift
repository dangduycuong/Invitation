//
//  Date.swift
//  Invitation
//
//  Created by Boss on 12/23/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit
extension Date {
    func offsetFrom(date: Date) -> String {

        let dayHourMinuteSecond: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self)
        
        
        let seconds = "\(difference.second ?? 0) giây"
        let minutes = "\(difference.minute ?? 0) phút" + " " + seconds
        let hours = "\(difference.hour ?? 0) giờ" + " " + minutes
        let days = "\(difference.day ?? 0) ngày" + " " + hours
        let months = "\(difference.month ?? 0) tháng" + " " + days
        let years = "\(difference.year ?? 0) năm" + " " + months

        if let year = difference.year, year > 0 { return years }
        if let month = difference.month, month > 0 { return months }
        
        if let day = difference.day, day          > 0 { return days }
        if let hour = difference.hour, hour       > 0 { return hours }
        if let minute = difference.minute, minute > 0 { return minutes }
        if let second = difference.second, second > 0 { return seconds }
        return ""
    }
    
}
