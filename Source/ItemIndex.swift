// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 19/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import CoreData
import Records

class ItemIndex {
    struct CodedItem: Codable {
        let name: String
        let price: Double?
        let weight: Double?
        let notes: String?
    }
    
    typealias CodedItems = [String: CodedItem]

    fileprivate let coded: CodedItems
    fileprivate var items: [String: Record]

    var itemIds: [String] {
        return items.keys.sorted(by: { $0 < $1 })
    }
    
    convenience init(name: String = "ItemTypes", bundle: Bundle = .main) throws {
        let url = Bundle.main.url(forResource: name, withExtension: "json")!
        try self.init(url: url)
    }
    
    init(url: URL) throws {
        let decoder = JSONDecoder()
        coded = try decoder.decode(CodedItems.self, from: try Data(contentsOf: url))
        items = [:]
    }

    func update(container: NSPersistentContainer) {
        var items: [String:Record] = [:]
        let context = container.viewContext
        for (itemKey, itemSpec) in coded {
            let itemID = "item-\(itemKey)"
            let item = Record.withID(itemID, in: context)
            item.set(itemSpec.name, forKey: .name)
            if let price = itemSpec.price {
                item.set(price, forKey: .itemGuidePrice)
            }
            if let weight = itemSpec.weight {
                item.set(weight, forKey: .itemWeight)
            }
            items[itemKey] = item
        }
        self.items = items
    }
    
    func item(withID itemID: String) -> Record? {
        items[itemID]
    }
    
    var randomItemID: String {
        items.keys.randomElement()!
    }
}
