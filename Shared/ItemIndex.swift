// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 19/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct ItemIndex {
    struct CodedItem: Codable {
        let name: String
        let price: Double?
        let weight: Double?
        let notes: String?
    }
    
    struct Item {
        let stats: [GameSystem.Stat:Any]

        init(_ coded: CodedItem) {
            var stats: [GameSystem.Stat:Any] = [:]
            stats[.name] = coded.name
            if let price = coded.price {
                stats[.itemGuidePrice] = price
            }
            if let weight = coded.weight {
                stats[.itemWeight] = weight
            }
            self.stats = stats
        }
        
        var name: String {
            stats[.name] as? String ?? ""
        }
    }
    
    typealias CodedItems = [String: CodedItem]
    typealias Items = [String:Item]

    fileprivate let items: Items

    var itemIds: [String] {
        return Array(items.keys)
    }
    
    init(name: String = "ItemTypes", bundle: Bundle = .main) throws {
        let url = Bundle.main.url(forResource: name, withExtension: "json")!
        try self.init(url: url)
    }
    
    init(url: URL) throws {
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(CodedItems.self, from: try Data(contentsOf: url))
        self.items = decoded.mapValues({ Item($0) })
    }

    func item(withID itemID: String) -> ItemIndex.Item? {
        let result = items[itemID]
        if result == nil {
            print("no item \(itemID)")
        }
        return result
    }
    
    var randomItemID: String {
        items.keys.randomElement()!
    }
}
