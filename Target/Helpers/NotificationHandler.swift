//
//  NotificationHandler.swift
//  Target
//
//  Created by Fadey Notchenko on 30.01.2023.
//

import Foundation
import NotificationCenter
import CoreData

class NotificationHandler {
    
    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { succes, error in
            if succes {
                print("allow")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    static func getNotifcationStatus(_ completion: @escaping (Bool) -> ()) {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    static func sendNotification(_ target: Target, dateStart: Date) {
        let dateComponents = calculateDate(selection: Period(rawValue: target.period!)!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = target.name
        content.body = bodyString(target)
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: target.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    static func deleteNotification(by id: String) {
        let center = UNUserNotificationCenter.current()
        center.removeDeliveredNotifications(withIdentifiers: [id])
        center.removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    public static func calculateDate(selection: Period) -> DateComponents {
        var dateComponents = DateComponents()
        dateComponents.timeZone = .current
        dateComponents.hour = 12
        
        return dateComponents
    }
    
    private static func bodyString(_ target: Target) -> String {
        var str = ""
        
        str += " \(NSLocalizedString("nottext", comment: "")) \(target.price) \(target.currency)"
        return str
    }
}

