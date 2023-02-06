//
//  Persistence.swift
//  Target
//
//  Created by Fadey Notchenko on 29.01.2023.
//

import CoreData
import SwiftUI
import WidgetKit

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
        
        guard let ud = UserDefaults(suiteName: Constants.appGroup) else { return }
        ud.removeObject(forKey: target.unwrappedID.uuidString)
        
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
            
            saveWidgetData(context: context)
        }
    }
    
    private static func saveWidgetData(context: NSManagedObjectContext) {
        guard let ud = UserDefaults(suiteName: Constants.appGroup) else { return }
        
        do {
            let req = NSFetchRequest<NSFetchRequestResult>(entityName: "TargetEntity")
            let targets = try context.fetch(req)
            
            var widgetTargets: [TargetWidgetEntity] = []
            
            for target in targets {
                if let target = target as? TargetEntity, target.dateFinish == nil {
                    
                    let targetWidget = TargetWidgetEntity(id: target.unwrappedID.uuidString, name: target.unwrappedName, price: target.price, current: target.currentMoney, color: target.unwrappedColor, currency: target.unwrappedCurrency)
                    
                    //append to UD array
                    widgetTargets.append(targetWidget)
                    
                    //append single entity
                    if let data = toData(targetWidget) {
                        ud.set(data, forKey: targetWidget.id)
                    }
                }
            }
            
            if let data = toData(widgetTargets) {
                ud.set(data, forKey: "targets")
            }
            
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            print(error.localizedDescription)
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
