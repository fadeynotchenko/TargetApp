//
//  Target+CoreDataProperties.swift
//  Target
//
//  Created by Fadey Notchenko on 29.01.2023.
//
//

import Foundation
import CoreData


extension Target {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Target> {
        return NSFetchRequest<Target>(entityName: "Target")
    }

    @NSManaged public var id: UUID
    @NSManaged public var dateStart: Date
    @NSManaged public var name: String
    @NSManaged public var price: Int64
    @NSManaged public var currentMoney: Int64
    @NSManaged public var currency: String
    @NSManaged public var color: Data
    @NSManaged public var dateFinish: Date?
    @NSManaged public var replenishment: NSNumber?
    @NSManaged public var period: String?

}

extension Target : Identifiable {

}
