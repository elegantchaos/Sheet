// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import UIKit
import SwiftUI

protocol RawIdentifiable: RawRepresentable, Identifiable { }

extension RawIdentifiable where RawValue == ID {
    var id: ID { rawValue }
}

class BasicFantasy: ObservableObject, GameRules {
    let savingThrows: SavingThrowTable
    
    required init(savingThrows: SavingThrowTable) {
        self.savingThrows = savingThrows
    }
    
    enum Stat: String, CaseIterable, Identifiable {
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
        
        var dependencies: [Stat] {
            let result: [Stat]
            switch self {
                case .hitsAndDamage: result = [.hits, .damage]
                default: result = []
            }
            return result
        }
        
        var isCalculated: Bool {
            switch self {
                case .hitsAndDamage:
                    return true
                    
                default:
                    return false
            }
        }
    }
    
    let topStats: [Stat] = [.race, .gender, .class, .level, .age, .hitsAndDamage]
    let abilityStats: [Stat] = [.strength, .intelligence, .wisdom, .dexterity, .constitution, .charisma]
    
    enum CharacterClass: String, CaseIterable, RawIdentifiable, Codable {
        case fighter
        case thief
        case mage
        case cleric
    }
    
    enum CharacterRace: String, CaseIterable, RawIdentifiable, Codable {
        case human
        case dwarf
        case elf
        case halfling
    }
    
    
    enum SavingThrow: String, CaseIterable, RawIdentifiable {
        case deathRayOrPoison
        case magicWands
        case paralysisOrPetrify
        case dragonBreath
        case spells

        var label: LocalizedStringKey {
            LocalizedStringKey(rawValue)
        }
    }

    static let modifierFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.positivePrefix = formatter.plusSign
        return formatter
    }()

    func savingThrowValue(for throwType: BasicFantasy.SavingThrow, `class` characterClass: BasicFantasy.CharacterClass, race: String, level: Int) -> Int? {
        let throwIndex = BasicFantasy.SavingThrow.allCases.firstIndex(of: throwType)!
        return savingThrows.value(for: throwIndex, class: characterClass.rawValue, race: race, level: level)
    }
    
    func randomize(sheet: CharacterSheet) {
        sheet.objectWillChange.send()

        for ability in abilityStats {
            let value = Int.random(in: 1...6) + Int.random(in: 1...6) + Int.random(in: 1...6)
            sheet.set(value, forKey: ability)
        }
        
        sheet.set("human", forKey: .race)
        sheet.set("male", forKey: .gender)
        sheet.set(BasicFantasy.CharacterClass.allCases.randomElement()!.rawValue, forKey: .class)
        sheet.set(Int.random(in: 1...20), forKey: .level)
        sheet.set(Int.random(in: 16...100), forKey: .age)
        let hits = Int.random(in: 16...100)
        sheet.set(hits, forKey: .hits)
        sheet.set(Int.random(in: 0...hits), forKey: .damage)

        try? sheet.managedObjectContext?.save()

    }
}


extension CharacterSheet {
    func string(forKey key: BasicFantasy.Stat) -> String? {
        stat(forKey: key) as? String
    }

    func integer(forKey key: BasicFantasy.Stat) -> Int? {
        stat(forKey: key) as? Int
    }
    
    func set(_ string: String, forKey key: BasicFantasy.Stat) {
        set(string, forKey: key.rawValue)
    }
    
    func set(_ integer: Int, forKey key: BasicFantasy.Stat) {
        set(integer, forKey: key.rawValue)
    }
    
    func has(key: BasicFantasy.Stat) -> Bool {
        if !has(key: key.rawValue) {
            for dependency in key.dependencies {
                if !has(key: dependency) { return false}
            }
        }
        
        return true
    }
    
    func editableString(forKey key: BasicFantasy.Stat) -> Binding<String> {
        editableString(forKey: key.rawValue)
    }

    func editableInteger(forKey key: BasicFantasy.Stat) -> Binding<Int> {
        editableInteger(forKey: key.rawValue)
    }

    func stat(forKey key: BasicFantasy.Stat) -> Any? {
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

    func modifierOffset(for detail: BasicFantasy.Stat) -> Int {
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
    
    func modifier(for detail: BasicFantasy.Stat) -> String {
        let offset = modifierOffset(for: detail)
        guard offset != 0, let string = BasicFantasy.modifierFormatter.string(for: offset) else { return "" }
        return string
    }

}
