
import Foundation

typealias ThrowEntries = [Int: [Int]]

struct CodedSavingThrowTable: Codable {
    public let classes: [String: [Int:String]]
}

class SavingThrowTable: ObservableObject {
    public let classes: [BasicFantasy.CharacterClass: ThrowEntries]

    init(url: URL) throws {
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(CodedSavingThrowTable.self, from: try Data(contentsOf: url))
        var classes: [BasicFantasy.CharacterClass: ThrowEntries] = [:]
        for (key, value) in decoded.classes {
            if let cclass = BasicFantasy.CharacterClass(rawValue: key) {
                classes[cclass] = value.mapValues({ $0.split(separator: " ").map({ Int($0)! }) })
                
            }
        }
        self.classes = classes
    }
    
    func value(for throwType: BasicFantasy.SavingThrow, `class` cclass: BasicFantasy.CharacterClass, level: Int) -> Int? {
        guard let entries = classes[cclass] else { return nil }
        
        var entryLevel = level
        while entryLevel > 0 {
            if let values = entries[entryLevel], let throwIndex = BasicFantasy.SavingThrow.allCases.firstIndex(of: throwType), throwIndex < values.count {
                return values[throwIndex]
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
