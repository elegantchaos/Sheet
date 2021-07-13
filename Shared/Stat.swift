// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import SwiftUI

struct Stat {
    let sheet: CharacterSheet
    let kind: Kind
    
    enum Kind: Int, CaseIterable {
        case strength
        case intelligence
        case wisdom
        case dexterity
        case constitution
        case charisma
    }

    var label: LocalizedStringKey {
        return "Stat\(kind.rawValue)"
    }
    
    var value: Int {
        switch kind {
            case .strength: return Int(sheet.strength)
            case .intelligence: return Int(sheet.intelligence)
            case .wisdom: return Int(sheet.wisdom)
            case .dexterity: return Int(sheet.dexterity)
            case .constitution: return Int(sheet.constitution)
            case .charisma: return Int(sheet.charisma)
        }
    }
    
    var valueString: String {
        "\(value)"
    }

    var modifier: Int {
        0
    }
    
    var modifierString: String {
        "\(modifier)"
    }
}

extension Stat.Kind: Identifiable {
    var id: Int { rawValue }
}

