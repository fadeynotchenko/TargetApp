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
    
    static func requestPermission(_ completion: @escaping (Bool) -> ()) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { succes, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            completion(succes)
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
    
    static func sendNotification(_ target: TargetEntity, dateStart: Date) {
        let dateComponents = getDateComponents(selection: Period(rawValue: target.period!)!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: target.unwrappedPeriod != Period.never.rawValue)
        
        let content = UNMutableNotificationContent()
        content.title = target.unwrappedName
        content.body = getBody(target)
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: target.unwrappedID.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    static func deleteNotification(by id: String) {
        let center = UNUserNotificationCenter.current()
        center.removeDeliveredNotifications(withIdentifiers: [id])
        center.removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    public static func getDateComponents(selection: Period) -> DateComponents {
        var dateComponents = DateComponents()
        dateComponents.timeZone = .current
        dateComponents.hour = 12
        
        switch selection {
        case .week:
            dateComponents = Calendar.current.dateComponents([.weekday], from: Date())
            return dateComponents
        case .month:
            dateComponents = Calendar.current.dateComponents([.day], from: Date())
            return dateComponents
        default:
            break
        }
        
        return dateComponents
    }
    
    private static func getBody(_ target: TargetEntity) -> String {
        var str = ""
        
        str += " \(NSLocalizedString("nottext", comment: "")) \(target.price) \(String(describing: target.currency))"
        return str
    }
}

