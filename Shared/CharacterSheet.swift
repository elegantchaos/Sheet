// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import SwiftUI
import CoreData

extension CharacterSheet {
    public override func awakeFromInsert() {
        uuid = UUID()
        set("Untitled", forKey: "name")
    }
    
    func has(key: String) -> Bool {
        guard let stats = stats as? Set<CharacterStat> else { return false}
        return stats.contains(where: { $0.key == key })
    }
    
    func stat(forKey key: String) -> Any? {
        guard let stats = stats as? Set<CharacterStat>, let stat = stats.first(where: { $0.key == key }) else { return nil }
        return stat.string ?? Int(stat.integer)
    }
    
    func string(forKey key: String) -> String? {
        return stat(forKey: key) as? String
    }

    func integer(forKey key: String) -> Int? {
        return stat(forKey: key) as? Int
    }

    func guaranteedStat(forKey key: String, sheet: CharacterSheet) -> CharacterStat {
        if let stats = stats as? Set<CharacterStat>, let stat = stats.first(where: { $0.key == key }) {
            return stat
        } else {
            let stat = CharacterStat(context: managedObjectContext!)
            stat.key = key
            stat.sheet = self
            return stat
        }
    }
    
    func set(_ string: String, forKey key: String) {
        let stat = guaranteedStat(forKey: key, sheet: self)
        if stat.string != string {
            objectWillChange.send()
            stat.string = string
        }
    }

    func set(_ integer: Int, forKey key: String) {
        let stat = guaranteedStat(forKey: key, sheet: self)
        let newValue = Int64(integer)
        if stat.integer != newValue {
            objectWillChange.send()
            stat.integer = newValue
        }
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

extension CharacterSheet {
    public var id: String {
        uuid = uuid ?? UUID()
        return uuid!.uuidString
    }
}
