//
//  Models.swift
//  Tracker
//
//  Created by Marina Kolbina on 02/04/2023.
//
 
import Foundation
import UIKit
 
 
struct TrackerCategory: Hashable{
    let id: UUID
    let label: String
    
    init(id: UUID = UUID(), label: String) {
        self.id = id
        self.label = label
    }
}
 
struct TrackerRecord: Hashable {
    let id: UUID
    let date: Date
    
    init(id: UUID = UUID(), date: Date) {
        self.id = id
        self.date = date
    }
}
 
struct Tracker: Identifiable {
    let id: UUID
    let label: String
    let emoji: String
    let color: UIColor
    let schedule: [Weekday]?
    
    init(id: UUID = UUID(), label: String, emoji: String, color: UIColor, schedule: [Weekday]?) {
        self.id = id
        self.label = label
        self.emoji = emoji
        self.color = color
        self.schedule = schedule
    }
}

struct StatisticsCellModel {
    let value: String
    let description: String
}
 
enum Weekday: String, CaseIterable, Comparable {
    case monday
    case tuesday
    case wednesday
    case thurshday
    case friday
    case saturday
    case sunday
    
    var day: (fullForm: String, shortForm: String, index: Int) {
        switch self {
        case .monday: return ("Понедельник", "Пн", 1)
        case .tuesday: return ("Вторник", "Вт", 2)
        case .wednesday: return ("Среда", "Ср", 3)
        case .thurshday: return ("Четверг", "Чт", 4)
        case .friday: return ("Пятница", "Пт", 5)
        case .saturday: return ("Суббота", "Сб", 6)
        case .sunday: return ("Воскресенье", "Вс", 7)
        }
    }
    
    static func < (lhs: Weekday, rhs: Weekday) -> Bool {
        return lhs.day.index < rhs.day.index
    }
}
//Далее определены структуры TrackerRecord и Tracker, а также перечисление Weekday.

//Структура TrackerRecord содержит два свойства: идентификатор трекера (trackerId) и дату (date).
//
//Структура Tracker содержит следующие свойства: идентификатор трекера (id), метку (label), эмодзи (emoji), цвет (color) и расписание (schedule) - массив дней недели типа Weekday.
//
//Перечисление Weekday содержит все дни недели и метод day, который возвращает кортеж с полным названием дня, коротким названием дня и его индексом в неделе. Также в нем определен оператор < для сравнения двух дней недели по их индексу.
