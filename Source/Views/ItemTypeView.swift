// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 16/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import Records
import SwiftUI

struct ItemTypeView: View {
    @EnvironmentObject var context: Context
    @EnvironmentObject var system: GameSystem
    @ObservedObject var item: Record
    
    var body: some View {
        return HStack {
            if context.editing {
                StatView(sheet: item, key: .name)
                    .multilineTextAlignment(.leading)

                let typeLabel = item.prototype?.string(forKey: .name) ?? "Custom"
                ItemTypeMenu(action: handleSetType) {
                    Text("Type: \(typeLabel)")
                        .foregroundColor(.accentColor)
                }
                                
            } else {
                let name = item.string(forKey: .name) ?? ""
                let fallback = item.prototype?.string(forKey: .name) ?? "Untitled"
                Text(name.isEmpty ? fallback : name)
            }
        }
    }
    
    func handleSetType(to itemID: String?) {
        if let id = itemID, let itemType = system.itemIndex.item(withID: id) {
            item.prototype = itemType
        } else {
            item.prototype = nil
        }
    }
}
