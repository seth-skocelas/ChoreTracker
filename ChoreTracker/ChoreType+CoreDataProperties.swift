//
//  ChoreType+CoreDataProperties.swift
//  ChoreTracker
//
//  Created by Seth Skocelas on 12/3/16.
//  Copyright © 2016 Seth Skocelas. All rights reserved.
//

import Foundation
import CoreData


extension ChoreType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChoreType> {
        return NSFetchRequest<ChoreType>(entityName: "ChoreType");
    }

    @NSManaged public var name: String?
    @NSManaged public var choreEvent: NSSet?

}

// MARK: Generated accessors for choreEvent
extension ChoreType {

    @objc(addChoreEventObject:)
    @NSManaged public func addToChoreEvent(_ value: ChoreEvent)

    @objc(removeChoreEventObject:)
    @NSManaged public func removeFromChoreEvent(_ value: ChoreEvent)

    @objc(addChoreEvent:)
    @NSManaged public func addToChoreEvent(_ values: NSSet)

    @objc(removeChoreEvent:)
    @NSManaged public func removeFromChoreEvent(_ values: NSSet)

}
