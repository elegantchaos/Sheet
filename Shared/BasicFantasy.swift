//
//  BasicFantasyRPG.swift
//  Sheet (iOS)
//
//  Created by Sam Deane on 13/07/2021.
//  Copyright © 2021 Elegant Chaos. All rights reserved.
//

import Foundation
import UIKit

struct BasicFantasy {
    enum Detail: String, CaseIterable, Identifiable {
        case race
        case gender
        case `class`
        case level
        case age
        case hits
        case damage
        
        case hitsAndDamage
        
        var id: String {
            rawValue
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

    enum CharacterClass: String, CaseIterable, Identifiable, Codable {
        case fighter
        case thief
        case mage
        case cleric
        
        var id: String { rawValue }
    }
    
    enum SavingThrow: Int, CaseIterable, Identifiable {
        case deathRayOrPoison
        case magicWands
        case paralysisOrPetrify
        case dragonBreath
        case spells

        var label: String {
            "Throw\(rawValue)"
        }

        var id: Int { rawValue }
    }
}


extension CharacterSheet {
    func string(withKey key: BasicFantasy.Detail) -> String? {
        stat(withKey: key) as? String
    }

    func integer(withKey key: BasicFantasy.Detail) -> Int? {
        stat(withKey: key) as? Int
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
    
    func stat(withKey key: BasicFantasy.Detail) -> Any? {
        switch key {
            case .hitsAndDamage:
                guard let hits = integer(withKey: .hits) else { return nil }
                guard let damage = integer(withKey: .damage) else { return nil }
                return "\(hits - damage) / \(hits)"
                
            default:
                return stat(withKey: key.rawValue)
        }
    }
    
    var characterClass: BasicFantasy.CharacterClass? {
        guard let string = string(withKey: .class) else { return nil }
        return BasicFantasy.CharacterClass(rawValue: string)
    }
}
