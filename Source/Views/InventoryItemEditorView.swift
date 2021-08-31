// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Records
import SwiftUI

struct InventoryItemEditorView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var system: GameSystem
    @ObservedObject var item: Record
    
    var body: some View {
        VStack {
            ItemTypeMenu(action: handleSetType) {
                Text(typeLabel)
                    .foregroundColor(.accentColor)
            }
            
            Spacer()

            let props: [GameSystem.Stat] = [.name, .itemCount, .itemWeight, .itemEquipped, .itemGuidePrice]
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(props) { prop in
                    HStack {
                        Spacer()
                        Text(prop.rawValue)
                    }

                    StatView(sheet: item, key: prop)
                }
            }
            
            Spacer()
            
            Button(action: handleDismiss) {
                Text("Done")
            }
        }
    }
    
    var typeLabel: String {
        let label: String
        if let type = item.prototype?.string(forKey: .name) {
            label = "Based on \(type)."
        } else {
            label = "Custom Item"
        }
        return label
    }
    
    func handleDismiss() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func handleSetType(to typeID: String?) {
        if let typeID = typeID, let itemType = system.itemIndex.item(withID: typeID) {
            item.prototype = itemType
        } else {
            item.prototype = nil
        }
    }
}
