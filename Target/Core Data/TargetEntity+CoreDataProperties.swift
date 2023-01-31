//
//  TargetEntity+CoreDataProperties.swift
//  Target
//
//  Created by Fadey Notchenko on 31.01.2023.
//
//

import Foundation
import CoreData
import SwiftUI

extension TargetEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TargetEntity> {
        return NSFetchRequest<TargetEntity>(entityName: "TargetEntity")
    }

    @NSManaged public var color: Data?
    @NSManaged public var currency: String?
    @NSManaged public var currentMoney: Int64
    @NSManaged public var dateFinish: Date?
    @NSManaged public var dateStart: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var period: String?
    @NSManaged public var price: Int64
    @NSManaged public var replenishment: Int64
    @NSManaged public var actions: NSSet?
    
    public var unwrappedColor: Data {
        color ?? UIColor.blue.encode()
    }

    public var unwrappedCurrency: String {
        currency ?? Currency.rub.rawValue
    }
    
    public var unwrappedDateStart: Date {
        dateStart ?? Date()
    }
    
    public var unwrappedID: UUID {
        id ?? UUID()
    }
    
    public var unwrappedName: String {
        name ?? ""
    }
    
    public var unwrappedPeriod: String {
        period ?? Period.never.rawValue
    }
    
    public var arrayOfActions: [ActionEntity] {
        let set = actions as? Set<ActionEntity> ?? []
        
        return set.sorted {
            $0.unwrappedDate > $1.unwrappedDate
        }
    }
}

// MARK: Generated accessors for actions
extension TargetEntity {

    @objc(addActionsObject:)
    @NSManaged public func addToActions(_ value: ActionEntity)

    @objc(removeActionsObject:)
    @NSManaged public func removeFromActions(_ value: ActionEntity)

    @objc(addActions:)
    @NSManaged public func addToActions(_ values: NSSet)

    @objc(removeActions:)
    @NSManaged public func removeFromActions(_ values: NSSet)

}

extension TargetEntity : Identifiable {

}
