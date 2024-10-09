//
//  NotificationManager.swift
//  AirQuality
//
//  Created by Adam Makowski on 30/09/2024.
//

import Foundation
import UserNotifications


class NotificationManager {
    
    static let instance = NotificationManager()
    
    func requestAuthorization() {
        
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error {
                print("Error requesting authorization: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Jakość powietrza"
        content.body = "Sprawdź jakość powietrza w swojej okolicy przed wyjściem z domu!"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 15
        dateComponents.minute = 8
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }

}
