//
//  BasicFantasyRPG.swift
//  Sheet (iOS)
//
//  Created by Sam Deane on 13/07/2021.
//  Copyright © 2021 Elegant Chaos. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

struct BasicFantasy {
    enum Detail: String, CaseIterable, Identifiable {
        // general
        case name
        case race
        case gender
        case `class`
        case level
        case age
        case hits
        case damage

        // abilities
        case strength
        case intelligence
        case wisdom
        case dexterity
        case constitution
        case charisma

        // calculated
        case hitsAndDamage
        
        var id: String {
            rawValue
        }
        
        var label: LocalizedStringKey {
            LocalizedStringKey(rawValue)
        }
        
        var dependencies: [Detail] {
            let result: [Detail]
            switch self {
                case .hitsAndDamage: result = [.hits, .damage]
                default: result = []
            }
            return result
        }
    }
    
    static let topDetails: [Detail] = [.race, .gender, .class, .level, .age, .hitsAndDamage]

    static let abilityDetails: [Detail] = [.strength, .intelligence, .wisdom, .dexterity, .constitution, .charisma]
    
    enum CharacterClass: String, CaseIterable, Identifiable, Codable {
        case fighter
        case thief
        case mage
        case cleric
        
        var id: String { rawValue }
    }
    
    enum SavingThrow: String, CaseIterable, Identifiable {
        case deathRayOrPoison
        case magicWands
        case paralysisOrPetrify
        case dragonBreath
        case spells

        var label: LocalizedStringKey {
            LocalizedStringKey(rawValue)
        }

        var id: String { rawValue }
    }

    static let modifierFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.positivePrefix = formatter.plusSign
        return formatter
    }()
}


extension CharacterSheet {
    func string(forKey key: BasicFantasy.Detail) -> String? {
        stat(forKey: key) as? String
    }

    func integer(forKey key: BasicFantasy.Detail) -> Int? {
        stat(forKey: key) as? Int
    }
    
    func set(_ string: String, forKey key: BasicFantasy.Detail) {
        set(string, forKey: key.rawValue)
    }
    
    func set(_ integer: Int, forKey key: BasicFantasy.Detail) {
        set(integer, forKey: key.rawValue)
    }
    
    func has(key: BasicFantasy.Detail) -> Bool {
        if !has(key: key.rawValue) {
            for dependency in key.dependencies {
                if !has(key: dependency) { return false}
            }
        }
        
        return true
    }
    
    func editableString(forKey key: BasicFantasy.Detail) -> Binding<String> {
        editableString(forKey: key.rawValue)
    }

    func editableInteger(forKey key: BasicFantasy.Detail) -> Binding<Int> {
        editableInteger(forKey: key.rawValue)
    }

    func stat(forKey key: BasicFantasy.Detail) -> Any? {
        switch key {
            case .hitsAndDamage:
                guard let hits = integer(forKey: .hits) else { return nil }
                guard let damage = integer(forKey: .damage) else { return nil }
                return "\(hits - damage) / \(hits)"
                
            default:
                return stat(forKey: key.rawValue)
        }
    }
    
    var characterClass: BasicFantasy.CharacterClass? {
        guard let string = string(forKey: .class) else { return nil }
        return BasicFantasy.CharacterClass(rawValue: string)
    }

    func modifierOffset(for detail: BasicFantasy.Detail) -> Int {
        guard let value = integer(forKey: detail) else { return 0 }
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
    
    func modifier(for detail: BasicFantasy.Detail) -> String {
        let offset = modifierOffset(for: detail)
        guard offset != 0, let string = BasicFantasy.modifierFormatter.string(for: offset) else { return "" }
        return string
    }
}
