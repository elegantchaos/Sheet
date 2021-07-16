// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 16/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

typealias CharacterSheet = Record

extension Record {
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
    
    func binding(forKey key: BasicFantasy.Stat) -> Any? {
        guard let stat = stat(forKey: key) else { return nil }
        guard !key.isCalculated else { return stat }
        
        switch stat {
            case is String:
                return stringBinding(forKey:key.rawValue)
                
            case is Int:
                return integerBinding(forKey:key.rawValue)
                
            default:
                return stat
        }
    }

    func modifiedCarryingCapacity(base: Int) -> Int {
        let modifier = Double(modifierOffset(for: .strength))
        let multiplier = 1.0 + ((modifier > 0) ? (0.1 * modifier) : (-0.2 * modifier))
        let modified = Double(base) * multiplier
        let rounded = Int(modified / 5.0) * 5
        return rounded
    }
    
    var isHalfling: Bool { string(forKey: .race)?.lowercased() == "halfling" }

    func guaranteedEntry(forKey key: BasicFantasy.Stat) -> RecordEntry {
        return guaranteedEntry(forKey: key.rawValue)
    }
    
    func stat(forKey key: BasicFantasy.Stat) -> Any? {
        switch key {
            case .hitsAndDamage:
                guard let hits = integer(forKey: .hits) else { return nil }
                guard let damage = integer(forKey: .damage) else { return nil }
                return "\(hits - damage) / \(hits)"
                
            case .capacityLight:
                return modifiedCarryingCapacity(base: isHalfling ? 50 : 60)

            case .capacityHeavy:
                return modifiedCarryingCapacity(base: isHalfling ? 100 : 150)

            case .capacityBoth:
                let isHalfling = self.isHalfling
                let light = modifiedCarryingCapacity(base: isHalfling ? 50 : 60)
                let heavy = modifiedCarryingCapacity(base: isHalfling ? 100 : 150)
                let carrying = integer(forKey: .carrying) ?? 0
                let status: WeightCarried.Status
                if carrying < light {
                    status = .normal
                } else if carrying < heavy {
                    status = .encumbered
                } else {
                    status = .overloaded
                }
                return WeightCarried(amount: carrying, status: status)

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
            case 18...Int.max: return 3
            default: return 0
        }
    }
    
    func modifier(for detail: BasicFantasy.Stat) -> String {
        let offset = modifierOffset(for: detail)
        guard offset != 0, let string = BasicFantasy.modifierFormatter.string(for: offset) else { return "" }
        return string
    }

}
