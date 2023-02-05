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
        target.dateFinish = Date().addingTimeInterval(-10000)
        
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
        DispatchQueue.main.async {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Target_app")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
