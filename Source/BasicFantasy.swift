// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import UIKit
import SwiftUI
import Records

protocol RawIdentifiable: RawRepresentable, Identifiable { }

extension RawIdentifiable where RawValue == ID {
    var id: ID { rawValue }
}

public class BasicFantasy: ObservableObject, GameRules {
    let savingThrows: SavingThrowTable
    let itemIndex: ItemIndex

    required init(savingThrows: SavingThrowTable, itemIndex: ItemIndex) {
        self.savingThrows = savingThrows
        self.itemIndex = itemIndex
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
        case carrying

        // abilities
        case strength
        case intelligence
        case wisdom
        case dexterity
        case constitution
        case charisma

        // calculated
        case movement
        case hitsAndDamage
        case capacityLight
        case capacityHeavy
        case weightCarried
        case itemTotalWeight
        
        
        // items
        case items
        case itemWeight
        case itemEquipped
        case itemGuidePrice
        case itemCount

        // armour
        case armourClass
        case armourAdjustment

        // weapons
        case meleeAdjustment
        case rangedAdjustment
        case damageAdjustment
        
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
                case .hitsAndDamage,
                        .capacityLight, .capacityHeavy, .weightCarried,
                        .movement, .itemTotalWeight:
                    return true
                    
                default:
                    return false
            }
        }
    }
    
    let topStatsViewing: [Stat] = [.race, .gender, .class, .level, .age, .weightCarried, .hitsAndDamage, .movement]
    let topStatsEditing: [Stat] = [.race, .gender, .class, .level, .age, .carrying, .damage, .movement]
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
        
        sheet.set(["human", "elf", "dwarf", "halfling"].randomElement()!, forKey: .race)
        sheet.set(["male", "female"].randomElement()!, forKey: .gender)
        sheet.set(BasicFantasy.CharacterClass.allCases.randomElement()!.rawValue, forKey: .class)
        sheet.set(Int.random(in: 1...20), forKey: .level)
        sheet.set(Int.random(in: 16...100), forKey: .age)
        let hits = Int.random(in: 16...100)
        sheet.set(hits, forKey: .hits)
        sheet.set(Int.random(in: 0...hits), forKey: .damage)
        sheet.set(Int.random(in: 0...200), forKey: .carrying)

        if let items = sheet.stat(forKey: .items) as? Set<Record> {
            for item in items {
                randomize(item: item)
            }
        }
        
        try? sheet.managedObjectContext?.save()

    }
    
    func randomize(item: Record) {
//        item.set(Double.random(in: 1...100), forKey: .itemWeight)
        item.set(Bool.random(), forKey: .itemEquipped)
//        item.set(Int.random(in: 12...18), forKey: .armourClass)
//        item.set(Int.random(in: 0...1), forKey: .armourAdjustment)
//        item.set(Int.random(in: 0...1), forKey: .meleeAdjustment)
//        item.set(Int.random(in: 0...1), forKey: .rangedAdjustment)
//        item.set(Int.random(in: 0...1), forKey: .damageAdjustment)
        
        let itemType = itemIndex.item(withID: itemIndex.randomItemID)
        item.prototype = itemType
    }
}

