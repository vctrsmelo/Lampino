//
//  NotificationManager.swift
//  Lampino
//
//  Created by Rodrigo Cardoso Buske on 07/03/18.
//  Copyright © 2018 Lampino Organization. All rights reserved.
//

import UserNotifications

class NotificationManager: NSObject {
    
    enum Categories: String {
        case confirmation
    }
    
    enum Actions: String {
        case turnLampsOn
    }
    
    enum Notifications: String {
        case arrivedHome
    }
    
    static let sharedInstance = NotificationManager()
    
    private let center = UNUserNotificationCenter.current()
    
    private override init() {
        super.init()        
    }
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound]
        
        self.center.requestAuthorization(options: options) { _, _ in
            self.registerNotifications()
        }
    }
    
    private func registerNotifications() {
        let turnLampsOnAction = UNNotificationAction(identifier: Actions.turnLampsOn.rawValue,
                                                     title: NSString.localizedUserNotificationString(forKey: "Yes", arguments: nil))
        
        let confirmationCategory = UNNotificationCategory(identifier: Categories.confirmation.rawValue,
                                                         actions: [turnLampsOnAction],
                                                         intentIdentifiers: [])
        
        let newCategories = Set([confirmationCategory])
        
        self.center.getNotificationCategories { categories in
            if categories != newCategories {
                self.center.setNotificationCategories(newCategories)
            }
        }
    }
    
    func scheduleArrivedHomeNotification() {
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = Categories.confirmation.rawValue
        content.title = NSString.localizedUserNotificationString(forKey: "Welcome Home", arguments: nil)
        content.subtitle = NSString.localizedUserNotificationString(forKey: "Would you like to turn all your lamps on?", arguments: nil)
        content.sound = UNNotificationSound.default()
        
        let request = UNNotificationRequest(identifier: Notifications.arrivedHome.rawValue, content: content, trigger: nil)
        
        self.center.add(request, withCompletionHandler: nil)
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        switch notification.request.content.categoryIdentifier {
        case Categories.confirmation.rawValue:
            completionHandler([])
            
        default:
            completionHandler([.alert, .badge])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case Actions.turnLampsOn.rawValue:
            ArduinoCommunicatorBluetooth.sharedInstance.setBrightness(100, to: nil)
            
        default:
            break
        }
        
        completionHandler()
    }
}
