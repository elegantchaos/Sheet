// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 16/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import Records
import SwiftUI

typealias CharacterSheet = Record

extension Record {
    func string(forKey key: GameSystem.Stat) -> String? {
        stat(forKey: key) as? String
    }

    func integer(forKey key: GameSystem.Stat) -> Int? {
        stat(forKey: key) as? Int
    }

    func integerBinding(forKey key: GameSystem.Stat) -> Binding<Int> {
        integerBinding(forKey: key.rawValue)
    }

    func stringBinding(forKey key: GameSystem.Stat) -> Binding<String> {
        stringBinding(forKey: key.rawValue)
    }
    
    func double(forKey key: GameSystem.Stat) -> Double? {
        stat(forKey: key) as? Double
    }

    func bool(forKey key: GameSystem.Stat) -> Bool? {
        stat(forKey: key) as? Bool
    }

    func set(_ string: String, forKey key: GameSystem.Stat) {
        set(string, forKey: key.rawValue)
    }
    
    func set(_ integer: Int, forKey key: GameSystem.Stat) {
        set(integer, forKey: key.rawValue)
    }

    func set(_ double: Double, forKey key: GameSystem.Stat) {
        set(double, forKey: key.rawValue)
    }

    func set(_ bool: Bool, forKey key: GameSystem.Stat) {
        set(bool, forKey: key.rawValue)
    }

    func append(_ record: Record, forKey key: GameSystem.Stat) {
        append(record, forKey: key.rawValue)
    }
        
    func has(key: GameSystem.Stat) -> Bool {
        if !has(key: key.rawValue) {
            for dependency in key.dependencies {
                if !has(key: dependency) { return false}
            }
        }
        
        return true
    }
    
    func binding(forKey key: GameSystem.Stat) -> Any? {
        guard let stat = stat(forKey: key) else { return nil }
        guard !key.isCalculated else { return stat }
        
        switch stat {
            case is String:
                return stringBinding(forKey: key.rawValue)
                
            case is Int:
                return integerBinding(forKey: key.rawValue)
                
            case is Double:
                return doubleBinding(forKey: key.rawValue)
                
            default:
                return stat
        }
    }

    func modifiedCarryingCapacity(base: Double) -> Double {
        let modifier = Double(modifierOffset(for: .strength))
        let multiplier = 1.0 + ((modifier > 0) ? (0.1 * modifier) : (-0.2 * modifier))
        let modified = base * multiplier
        let rounded = Int(modified / 5.0) * 5
        return Double(rounded)
    }
    
    var isHalfling: Bool { string(forKey: .race)?.lowercased() == "halfling" }

    func guaranteedEntry(forKey key: GameSystem.Stat) -> RecordEntry {
        return guaranteedEntry(forKey: key.rawValue)
    }
    
    func stat(forKey key: GameSystem.Stat) -> Any? {
        switch key {
            case .hitsAndDamage:    return hitsAndDamage
            case .capacityLight:    return capacityLight
            case .capacityHeavy:    return capacityHeavy
            case .weightCarried:    return weightCarried
            case .movement:         return movement
            case .itemTotalWeight:  return itemTotalWeight
                
            default:
                return stat(forKey: key.rawValue)
        }
    }

    var itemTotalWeight: Double {
        let count = integer(forKey: .itemCount) ?? 1
        let weight = double(forKey: .itemWeight) ?? 0.0
        return weight * Double(count)
    }
    
    var movement: String {
        let baseMovement: Int
        switch weightCarried.status {
            case .normal: baseMovement = 40
            case .encumbered: baseMovement = 30
            case .overloaded: return "none"
        }
        
        let movement = baseMovement + armourMovementPenalty
        return "\(movement)'"
    }
    
    var armourMovementPenalty: Int {
        return 0
    }
    
    var hitsAndDamage: String? {
        guard let hits = integer(forKey: .hits) else { return nil }
        guard let damage = integer(forKey: .damage) else { return nil }
        return "\(hits - damage) / \(hits)"
    }
    
    var capacityLight: Double {
        return modifiedCarryingCapacity(base: isHalfling ? 50 : 60)
    }
    
    var capacityHeavy: Double {
        return modifiedCarryingCapacity(base: isHalfling ? 100 : 150)
    }
    
    var itemsWeight: Double {
        var weight = 0.0
        if let items = stat(forKey: .items) as? Set<Record> {
            for item in items {
                weight += item.double(forKey: .itemTotalWeight) ?? 0
            }
        }
        
        return weight
    }
    
    var weightCarried: WeightCarried {
        var carrying = double(forKey: .carrying) ?? 0.0
        carrying += itemsWeight
        
        let status: WeightCarried.Status
        if carrying < capacityLight {
            status = .normal
        } else if carrying < capacityHeavy {
            status = .encumbered
        } else {
            status = .overloaded
        }
        return WeightCarried(amount: carrying, status: status)
    }
    
    var characterClass: BasicFantasy.CharacterClass? {
        guard let string = string(forKey: .class) else { return nil }
        return BasicFantasy.CharacterClass(rawValue: string)
    }

    func modifierOffset(for detail: GameSystem.Stat) -> Int {
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
    
    func modifier(for detail: GameSystem.Stat) -> String {
        let offset = modifierOffset(for: detail)
        guard offset != 0, let string = BasicFantasy.modifierFormatter.string(for: offset) else { return "" }
        return string
    }

}

// MARK: Generic Export

extension Record {
    var asRecord: [String:Any] {
        var record: [String:Any] = [:]

//        record["id"] = id
        
        if let prototype = prototype {
            record["type"] = prototype.id
        }
        
        if let entries = entries as? Set<RecordEntry> {
            for entry in entries {
                if let key = entry.key {
                    let value = stat(forKey: key)
                    if let array = value as? Set<Record> {
                        let values = array.map { $0.asRecord }
                        record[key] = values
                    } else {
                        record[key] = value
                    }
                }
            }
        }
        
        return record
    }
}

// MARK: JSON Export

extension Record: JSONDataProvider {
    var jsonExportName: String {
        let name = string(forKey: .name) ?? "Untitled"
        return "\(name) Export"
    }
    
    var asJSONData: Data {
        do {
            return try JSONSerialization.data(withJSONObject: asRecord, options: .prettyPrinted)
        } catch {
            return Data()
        }
    }

    func set(fromJSONData data: Data) {
        
    }
    
    func handleExported(_ result: Result<URL, Error>) {
    }
}
