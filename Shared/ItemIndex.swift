//
//  ItemTypeIndex.swift
//  ItemTypeIndex
//
//  Created by Sam Deane on 16/07/2021.
//  Copyright © 2021 Elegant Chaos. All rights reserved.
//

import Foundation

struct ItemIndex {
    struct CodedItem: Codable {
        let name: String
        let price: String?
        let weight: Int?
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
    }

    struct ItemSpec {
        let id: String?
        let item: Record?
    }
    
    typealias CodedItems = [String: CodedItem]
    typealias Items = [String:Item]

    let items: Items

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

}
