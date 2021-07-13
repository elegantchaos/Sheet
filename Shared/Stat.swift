// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import SwiftUI

struct Stat {
    let sheet: CharacterSheet
    let kind: Kind
    
    static let modifierFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.positivePrefix = formatter.plusSign
        return formatter
    }()
    
    enum Kind: Int, CaseIterable {
        case strength
        case intelligence
        case wisdom
        case dexterity
        case constitution
        case charisma
    }
    
    var label: String { // TODO: translation
        switch kind {
            case .strength: return "Strength"
            case .intelligence: return "Intelligence"
            case .wisdom: return "Wisdom"
            case .dexterity: return "Dexterity"
            case .constitution: return "Consitution"
            case .charisma: return "Charisma"
        }
    }
    
    var value: Int {
        get {
            switch kind {
                case .strength: return Int(sheet.strength)
                case .intelligence: return Int(sheet.intelligence)
                case .wisdom: return Int(sheet.wisdom)
                case .dexterity: return Int(sheet.dexterity)
                case .constitution: return Int(sheet.constitution)
                case .charisma: return Int(sheet.charisma)
            }
        }
        
        set {
            update(to: newValue)
        }
    }
    
    func update(to newValue: Int) {
        switch kind {
            case .strength: sheet.strength = Int16(newValue)
            case .intelligence: sheet.intelligence = Int16(newValue)
            case .wisdom: sheet.wisdom = Int16(newValue)
            case .dexterity: sheet.dexterity = Int16(newValue)
            case .constitution: sheet.constitution = Int16(newValue)
            case .charisma: sheet.charisma = Int16(newValue)
        }
    }
    
    var valueString: String {
        "\(value)"
    }
    
    var modifier: Int {
        switch value {
            case 3: return -3
            case 4...5: return -2
            case 6...8: return -1
            case 13...15: return 1
            case 16...17: return 2
            case 18: return 3
            default: return 0
        }
    }
    
//    var modifierString: String {
//        "\(modifier, formatter: Self.modifierFormatter)"
//    }
    
    func randomize() {
        var value = 0
        for _ in 1...3 {
            value += Int.random(in: 1...6)
        }
        update(to: value)
    }
}

extension Stat.Kind: Identifiable {
    var id: Int { rawValue }
}

