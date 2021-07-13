// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

extension CharacterSheet {
    public override func awakeFromInsert() {
        uuid = UUID()
    }
    
    func stat(_ kind: Ability.Kind) -> Ability {
        Ability(sheet: self, kind: kind)
    }
    
    func has(key: String) -> Bool {
        guard let stats = stats as? Set<CharacterStat> else { return false}
        return stats.contains(where: { $0.key == key })
    }
    
    func string(withKey key: String) -> String? {
        guard let stats = stats as? Set<CharacterStat>, let stat = stats.first(where: { $0.key == key }), let string = stat.string else { return nil }
        return string
    }

    func integer(withKey key: String) -> Int? {
        guard let stats = stats as? Set<CharacterStat>, let stat = stats.first(where: { $0.key == key }) else { return nil }
        return Int(stat.integer)
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

    func randomize() {
        for kind in Ability.Kind.allCases {
            let stat = stat(kind)
            stat.randomize()
        }
        
        set("human", forKey: "race")
        set("male", forKey: "gender")
        
        try? managedObjectContext?.save()
    }
}

extension CharacterSheet {
    public var id: String {
        uuid = uuid ?? UUID()
        return uuid!.uuidString
    }
}
