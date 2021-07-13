// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import SwiftUI

struct Ability {
    let sheet: CharacterSheet
    let kind: Kind
    
    static let modifierFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.positivePrefix = formatter.plusSign
        return formatter
    }()
    
    enum Kind: String, CaseIterable {
        case strength
        case intelligence
        case wisdom
        case dexterity
        case constitution
        case charisma
    }
    
    var label: String {
        return kind.rawValue.capitalized
    }
    
    var value: Int {
        get {
            sheet.integer(withKey: kind.rawValue) ?? 0
        }
        
        set {
            update(to: newValue)
        }
    }
    
    func update(to newValue: Int) {
        sheet.set(newValue, forKey: kind.rawValue)
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

extension Ability.Kind: Identifiable {
    var id: String { rawValue }
}

