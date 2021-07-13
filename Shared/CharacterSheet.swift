// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

extension CharacterSheet {
    public override func awakeFromInsert() {
        uuid = UUID()
    }
    
    func stat(_ kind: Stat.Kind) -> Stat {
        Stat(sheet: self, kind: kind)
    }
    
    func randomize() {
        for kind in Stat.Kind.allCases {
            let stat = stat(kind)
            stat.randomize()
        }
        
        try? managedObjectContext?.save()
    }
}

extension CharacterSheet {
    public var id: String {
        uuid = uuid ?? UUID()
        return uuid!.uuidString
    }
}
