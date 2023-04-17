//
//  Date+extension.swift
//  Tracker
//
//  Created by Marina Kolbina on 16/04/2023.
//

import Foundation

extension Calendar {
    static let mondayFirst: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        return calendar
    }()
}
