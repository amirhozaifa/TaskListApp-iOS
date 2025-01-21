//
//  Task.swift
//  TaskList
//
//  Created by Amir Hozaifa on 15/1/25.
//

import Foundation

struct Task: Identifiable, Hashable, Codable {
    let id: String
    let title: String
    let description: String
    let date: Date
    let priority: Priority
    let isReminderOn: Bool
    let remindImmediately: Bool
    let reminderDays: Int
    let reminderHours: Int
    let reminderMinutes: Int
    
    
    init() {
        self.id = UUID().uuidString
        self.title = ""
        self.description = ""
        self.date = Calendar.current.date(bySetting: .second, value: 0, of: .now) ?? .now
        self.priority = .normal
        self.isReminderOn = false
        self.remindImmediately = true
        self.reminderDays = 0
        self.reminderHours = 0
        self.reminderMinutes = 0
    }
    
    init(title: String, description: String, date: Date) {
        self.id = UUID().uuidString
        self.title = title
        self.description = description
        self.date = Calendar.current.date(bySetting: .second, value: 0, of: date) ?? date
        self.priority = .normal
        self.isReminderOn = false
        self.remindImmediately = true
        self.reminderDays = 0
        self.reminderHours = 0
        self.reminderMinutes = 0
    }
    
    init(title: String, description: String, date: Date, priority: Priority, isReminderOn: Bool, remindImmediately: Bool, reminderDays: Int, reminderHours: Int, reminderMinutes: Int) {
        self.id = UUID().uuidString
        self.title = title
        self.description = description
        self.date = Calendar.current.date(bySetting: .second, value: 0, of: date) ?? date
        self.priority = priority
        self.isReminderOn = isReminderOn
        self.remindImmediately = remindImmediately
        self.reminderDays = reminderDays
        self.reminderHours = reminderHours
        self.reminderMinutes = reminderMinutes
    }
    
    init(id: String, title: String, description: String, date: Date, priority: Priority, isReminderOn: Bool, remindImmediately: Bool, reminderDays: Int, reminderHours: Int, reminderMinutes: Int) {
        self.id = id
        self.title = title
        self.description = description
        self.date = Calendar.current.date(bySetting: .second, value: 0, of: date) ?? date
        self.priority = priority
        self.isReminderOn = isReminderOn
        self.remindImmediately = remindImmediately
        self.reminderDays = reminderDays
        self.reminderHours = reminderHours
        self.reminderMinutes = reminderMinutes
    }
    
    static func isEqual(_ task1: Task, _ task2: Task) -> Bool {
        return task1.title == task2.title &&
            task1.description == task2.description &&
            task1.date == task2.date &&
            task1.priority == task2.priority &&
            task1.isReminderOn == task2.isReminderOn &&
            task1.remindImmediately == task2.remindImmediately &&
            task1.reminderDays == task2.reminderDays &&
            task1.reminderHours == task2.reminderHours &&
            task1.reminderMinutes == task2.reminderMinutes
    }
    
    enum Priority: String, Codable {
        case high, normal, low
    }
}
