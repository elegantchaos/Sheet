
import Foundation

struct CodedSavingThrowTable: Codable {
    public let classes: [String: [Int:String]]
}

class SavingThrowTable: ObservableObject {
    typealias ThrowsByClass = [String: [Int: [Int]]]
    public let classes: ThrowsByClass

    init(url: URL) throws {
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(CodedSavingThrowTable.self, from: try Data(contentsOf: url))
        var classes: ThrowsByClass = [:]
        for (key, value) in decoded.classes {
            classes[key] = value.mapValues({ $0.split(separator: " ").map({ Int($0)! }) })
        }
        self.classes = classes
    }
    
    init() {
        classes = [:]
    }
    
    func value(for throwIndex: Int, `class` cclass: String, level: Int) -> Int? {
        guard let entries = classes[cclass] else { return nil }
        
        var entryLevel = level
        while entryLevel > 0 {
            if let values = entries[entryLevel], throwIndex < values.count {
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
