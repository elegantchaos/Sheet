// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 16/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import SwiftUI

struct ItemTypeView: View {
    @EnvironmentObject var context: Context
    @EnvironmentObject var system: GameSystem
    
    let spec: ItemIndex.ItemSpec
    
    var body: some View {
        let label: String
        let isCustom: Bool

        if let id = spec.id, let item = system.itemIndex.item(withID: id), let name = item.stats[.name] as? String {
            label = name
            isCustom = false
        } else if !context.editing, let item = spec.item, let name = item.string(forKey: .name) {
            label = name
            isCustom = true
        } else {
            label = "Custom:"
            isCustom = true
        }
        
        return HStack {
            if context.editing {
                Menu(label) {
                    Button(action: handleSetCustom ) {
                        Text("Custom")
                    }

                    Divider()
                    
                    ForEach(system.itemIndex.itemIds, id: \.self) { item in
                        Button(action: { handleSetType(to: item) }) {
                            Text(item)
                        }
                    }
                }
                
                if isCustom, let item = spec.item {
                    EditableStatView(sheet: item, key: .name)
                        .multilineTextAlignment(.leading)
                }
            } else {
                Text(label)
            }
        }
    }
    
    func handleSetType(to itemType: String) {
        if let item = spec.item {
            item.set(itemType, forKey: .itemType)
        }
    }
    
    func handleSetCustom() {
        if let item = spec.item {
            item.set("", forKey: .itemType)
        }
    }
}
