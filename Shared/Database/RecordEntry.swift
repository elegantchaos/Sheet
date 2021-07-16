//
//  RecordEntry.swift
//  RecordEntry
//
//  Created by Sam Deane on 16/07/2021.
//  Copyright © 2021 Elegant Chaos. All rights reserved.
//

import CoreData

class RecordEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecordEntry> {
        return NSFetchRequest<RecordEntry>(entityName: "RecordEntry")
    }

    @NSManaged public var integer: Int64
    @NSManaged public var key: String?
    @NSManaged public var string: String?
    @NSManaged public var children: NSSet?
    @NSManaged public var record: Record?

}

// MARK: Generated accessors for children
extension RecordEntry {

    @objc(addChildrenObject:)
    @NSManaged public func addToChildren(_ value: Record)

    @objc(removeChildrenObject:)
    @NSManaged public func removeFromChildren(_ value: Record)

    @objc(addChildren:)
    @NSManaged public func addToChildren(_ values: NSSet)

    @objc(removeChildren:)
    @NSManaged public func removeFromChildren(_ values: NSSet)

}

extension RecordEntry : Identifiable {

}
