// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 16/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import SwiftUI

struct ItemTypeView: View {
    @EnvironmentObject var system: GameSystem
    
    let spec: ItemIndex.ItemSpec
    
    var body: some View {
        let label: String
        if let id = spec.id, let item = system.itemIndex.items[id], let name = item.stats[.name] as? String {
            label = name
        } else {
            label = "<select>"
        }
        
        return Menu(label) {
            ForEach(system.itemIndex.itemIds, id: \.self) { item in
                Button(action: { handleSetType(to: item) }) {
                    Text(item)
                }
            }
        }
    }
    
    func handleSetType(to itemType: String) {
        if let item = spec.item {
            item.set(itemType, forKey: .itemType)
        }
    }
}
