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
    
    func stat(withKey key: String) -> Any? {
        guard let stats = stats as? Set<CharacterStat>, let stat = stats.first(where: { $0.key == key }) else { return nil }
        return stat.string ?? Int(stat.integer)
    }
    
    func string(withKey key: String) -> String? {
        return stat(withKey: key) as? String
    }

    func integer(withKey key: String) -> Int? {
        return stat(withKey: key) as? Int
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
        objectWillChange.send()

        for kind in Ability.Kind.allCases {
            let stat = stat(kind)
            stat.randomize()
        }
        
        set("human", forKey: .race)
        set("male", forKey: .gender)
        set(BasicFantasy.CharacterClass.allCases.randomElement()!.rawValue, forKey: .class)
        set(Int.random(in: 1...20), forKey: .level)
        set(Int.random(in: 16...100), forKey: .age)
        let hits = Int.random(in: 16...100)
        set(hits, forKey: .hits)
        set(Int.random(in: 0...hits), forKey: .damage)

        try? managedObjectContext?.save()
    }
}

extension CharacterSheet {
    public var id: String {
        uuid = uuid ?? UUID()
        return uuid!.uuidString
    }
}
