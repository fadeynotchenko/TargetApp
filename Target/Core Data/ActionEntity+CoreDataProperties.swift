//
//  ActionEntity+CoreDataProperties.swift
//  Target
//
//  Created by Fadey Notchenko on 31.01.2023.
//
//

import Foundation
import CoreData


extension ActionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActionEntity> {
        return NSFetchRequest<ActionEntity>(entityName: "ActionEntity")
    }

    @NSManaged public var value: Int64
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var action: String?
    @NSManaged public var relationship: TargetEntity?

    public var unwrappedDate: Date {
        date ?? Date()
    }

    public var unwrappedID: UUID {
        id ?? UUID()
    }
    
    public var unwrappedAction: String {
        action ?? Action.minus.rawValue
    }
}

extension ActionEntity : Identifiable {

}
