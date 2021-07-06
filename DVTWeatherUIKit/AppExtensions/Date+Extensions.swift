//
//  Date+Extensions.swift
//  DVTWeatherUIKit
//
//  Created by Kurt Jacobs
//

import Foundation

extension Date {
    public var removeTimeStamp : Date? {
        let calendar = Calendar.current
        guard let date = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: self)) else { return nil }
        return date
   }
}
