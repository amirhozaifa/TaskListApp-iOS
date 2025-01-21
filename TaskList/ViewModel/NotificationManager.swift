//
//  NotificationManager.swift
//  TaskList
//
//  Created by Amir Hozaifa on 20/1/25.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    static let instance = NotificationManager()
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            
        }
    }
    
    func scheduleNotification(taskTitle: String, taskDate: Date, reminderDate: Date) -> String? {
        guard reminderDate.timeIntervalSince(Date()) > 0 else {
            return nil
        }
        
        let reminderTime = taskDate.timeIntervalSince(reminderDate)
        let content = UNMutableNotificationContent()

        let days = Int(reminderTime) / 86400
        let hours = (Int(reminderTime) % 86400) / 3600
        let minutes = (Int(reminderTime) % 3600) / 60
        var subtitle: String = ""
        if days > 0 {
            subtitle += "\(days) day" + (days > 1 ? "s" : "")
        }
        if hours > 0 {
            subtitle += "\(hours) hour" + (hours > 1 ? "s" : "")
        }
        if minutes > 0 {
            subtitle += "\(minutes) minute" + (minutes > 1 ? "s" : "")
        }
        if !subtitle.isEmpty {
            subtitle = "in " + subtitle
        }
        
        content.title = taskTitle
        content.subtitle = subtitle
        content.sound = .default
                
        var dateComponents = DateComponents()
        dateComponents.year = Calendar.current.component(.year, from: reminderDate)
        dateComponents.day = Calendar.current.component(.day, from: reminderDate)
        dateComponents.hour = Calendar.current.component(.hour, from: reminderDate)
        dateComponents.minute = Calendar.current.component(.minute, from: reminderDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        
        let notificationIdentifier = request.identifier
        
        UNUserNotificationCenter.current().add(request)
        return notificationIdentifier
    }
    
    func deleteNotification(_ notificationIdentifier: String?) {
        guard let identifier = notificationIdentifier else {
            return
        }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
