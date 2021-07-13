// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

extension CharacterStat {
    
}
extension CharacterSheet {
    public override func awakeFromInsert() {
        uuid = UUID()
    }
    
    func stat(_ kind: Stat.Kind) -> Stat {
        Stat(sheet: self, kind: kind)
    }
    
    func string(withKey key: String) -> String? {
        guard let stats = stats as? Set<CharacterStat>, let stat = stats.first(where: { $0.key == key }), let string = stat.string else { return nil }
        return string
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

    func randomize() {
        for kind in Stat.Kind.allCases {
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
