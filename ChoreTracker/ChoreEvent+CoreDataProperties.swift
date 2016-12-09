//
//  ChoreEvent+CoreDataProperties.swift
//  ChoreTracker
//
//  Created by Seth Skocelas on 12/3/16.
//  Copyright © 2016 Seth Skocelas. All rights reserved.
//

import Foundation
import CoreData


extension ChoreEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChoreEvent> {
        return NSFetchRequest<ChoreEvent>(entityName: "ChoreEvent");
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var notes: String?
    @NSManaged public var choreType: ChoreType?

}
