
import Foundation

extension String {
    var asIntegers: [Int] {
        split(separator: " ").map({ Int($0)! })
    }
}

struct SavingThrowTable {
    typealias ThrowsByClass = [String: [Int: [Int]]]
    typealias ModifiersByRace = [String: [Int]]

    private let classValues: ThrowsByClass
    private let raceModifiers: ModifiersByRace

    struct CodedTable: Codable {
        let classes: [String: [Int:String]]
        let races: [String: String]
    }

    init(url: URL) throws {
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(CodedTable.self, from: try Data(contentsOf: url))
        var classes: ThrowsByClass = [:]
        for (key, value) in decoded.classes {
            classes[key] = value.mapValues({ $0.asIntegers })
        }
        self.classValues = classes
        self.raceModifiers = decoded.races.mapValues({ $0.asIntegers })
    }
    
    init() {
        classValues = [:]
        raceModifiers = [:]
    }
    
    func value(for throwIndex: Int, `class` cclass: String, race: String, level: Int) -> Int? {
        guard let entries = classValues[cclass] else { return nil }
    
        let modifiers = raceModifiers[race.lowercased()] ?? [0, 0, 0, 0, 0]
            
        var entryLevel = level
        while entryLevel > 0 {
            if let values = entries[entryLevel], throwIndex < values.count, throwIndex < modifiers.count {
                return values[throwIndex] + modifiers[throwIndex]
            }
            entryLevel -= 1
        }
        
        return nil
    }
}

/*
 1: [11, 12, 14, 16, 15],
 2: [10, 11, 13, 15, 14]

 */
