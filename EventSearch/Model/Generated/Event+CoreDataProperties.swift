//
//  Event+CoreDataProperties.swift
//  EventSearch
//
//  Created by Tyler Poland on 7/28/18.
//  Copyright © 2018 Tyler Poland. All rights reserved.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var location: String?
    @NSManaged public var imageURL: String?

}
