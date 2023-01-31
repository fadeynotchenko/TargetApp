//
//  Persistence.swift
//  Target
//
//  Created by Fadey Notchenko on 29.01.2023.
//

import CoreData
import SwiftUI

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let target = TargetEntity(context: viewContext)
        target.id = UUID()
        target.dateStart = Date().addingTimeInterval(-1000000)
        target.name = "Test Target"
        target.price = 1000
        target.currentMoney = 750
        target.color = UIColor.purple.encode()
        
        for i in 1...3 {
            let action = ActionEntity(context: viewContext)
            action.id = UUID()
            action.date = Date().stripTime()
            action.value = Int64(i * 50)
            action.action = Action.plus.rawValue
            
            target.addToActions(action)
        }
        
        //
        
        let target2 = TargetEntity(context: viewContext)
        target2.id = UUID()
        target2.dateStart = Date().addingTimeInterval(-10000000)
        target2.name = "Test Target"
        target2.price = 20000
        target2.currentMoney = 14000
        target2.color = UIColor.orange.encode()
        
        for i in 1...3 {
            let action = ActionEntity(context: viewContext)
            action.id = UUID()
            action.date = Date().stripTime()
            action.value = Int64(i * 50)
            action.action = Action.plus.rawValue
            
            target2.addToActions(action)
        }
        
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
        
        return result
    }()

    let container: NSPersistentContainer
    
    static func deleteTarget(_ target: TargetEntity, context: NSManagedObjectContext) {
        NotificationHandler.deleteNotification(by: target.unwrappedID.uuidString)
        
        context.delete(target)
        
        save(context: context)
    }
    
    static func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Target")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
