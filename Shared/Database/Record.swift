// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import SwiftUI
import CoreData


extension Record {
    enum EntryType: Int {
        case array
        case string
        case integer
    }
    
    public override func awakeFromInsert() {
        uuid = UUID()
        set("Untitled", forKey: "name")
    }
    
    func has(key: String) -> Bool {
        guard let stats = entries as? Set<RecordEntry> else { return false}
        return stats.contains(where: { $0.key == key })
    }
    
    func stat(forKey key: String) -> Any? {
        guard let stats = entries as? Set<RecordEntry>, let stat = stats.first(where: { $0.key == key }) else { return nil }
        guard let type = EntryType(rawValue: Int(stat.type)) else { return nil }
        switch type {
            case .integer: return Int(stat.integer)
            case .string: return stat.string
            case .array: return stat.children as? Set<Record>
        }
    }
    
    func string(forKey key: String) -> String? {
        return stat(forKey: key) as? String
    }

    func integer(forKey key: String) -> Int? {
        return stat(forKey: key) as? Int
    }

    func guaranteedEntry(forKey key: String) -> RecordEntry {
        if let stats = entries as? Set<RecordEntry>, let stat = stats.first(where: { $0.key == key }) {
            return stat
        } else {
            let stat = RecordEntry(context: managedObjectContext!)
            stat.key = key
            stat.record = self
            return stat
        }
    }
    
    func set(_ string: String, forKey key: String) {
        let entry = guaranteedEntry(forKey: key)
        let type = Int16(EntryType.string.rawValue)
        if (entry.type != type) || (entry.string != string) {
            objectWillChange.send()
            entry.string = string
            entry.type = type
        }
    }

    func set(_ integer: Int, forKey key: String) {
        let entry = guaranteedEntry(forKey: key)
        let type = Int16(EntryType.integer.rawValue)
        let newValue = Int64(integer)
        if (entry.type != type) || (entry.integer != newValue) {
            objectWillChange.send()
            entry.integer = newValue
            entry.type = type
        }
    }
    
    func append(_ record: Record, forKey key: String) {
        let entry = guaranteedEntry(forKey: key)
        objectWillChange.send()
        record.parent = entry
        entry.type = Int16(EntryType.array.rawValue)
    }
    
    func stringBinding(forKey key: String) -> Binding<String> {
        return Binding<String>(
            get: { self.string(forKey: key) ?? "" },
            set: { newValue in self.set(newValue, forKey: key) }
            )
    }

    func integerBinding(forKey key: String) -> Binding<Int> {
        return Binding<Int>(
            get: { self.integer(forKey: key) ?? 0 },
            set: { newValue in self.set(newValue, forKey: key) }
            )
    }

    func save() throws {
        try managedObjectContext?.save()
    }
}

extension Record {
    public var id: String {
        uuid = uuid ?? UUID()
        return uuid!.uuidString
    }
}
