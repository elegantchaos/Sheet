// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import SwiftUI

extension CharacterSheet {
    public override func awakeFromInsert() {
        uuid = UUID()
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

    func set(_ string: String, forKey key: String) {
        if var stats = stats as? Set<CharacterStat> {
            if let stat = stats.first(where: { $0.key == key }) {
                stat.string = string
            } else {
                let stat = CharacterStat(context: self.managedObjectContext!)
                stat.key = key
                stat.string = string
                stats.insert(stat)
                self.stats = stats as NSSet
            }
        }
    }

    func set(_ integer: Int, forKey key: String) {
        if var stats = stats as? Set<CharacterStat> {
            if let stat = stats.first(where: { $0.key == key }) {
                stat.integer = Int64(integer)
            } else {
                let stat = CharacterStat(context: self.managedObjectContext!)
                stat.key = key
                stat.integer = Int64(integer)
                stats.insert(stat)
                self.stats = stats as NSSet
            }
        }
    }
    
    var editableName: String {
        get { name ?? "" }
        set { name = newValue }
    }
    
    func editableString(forKey key: String) -> Binding<String> {
        return Binding<String>(
            get: { self.string(forKey: key) ?? "" },
            set: { newValue in self.set(newValue, forKey: key) }
            )
    }

    func editableInteger(forKey key: String) -> Binding<Int> {
        return Binding<Int>(
            get: { self.integer(forKey: key) ?? 0 },
            set: { newValue in self.set(newValue, forKey: key) }
            )
    }

}

extension CharacterSheet {
    public var id: String {
        uuid = uuid ?? UUID()
        return uuid!.uuidString
    }
}
