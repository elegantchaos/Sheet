// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 16/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import SwiftUI

struct ItemTypeView: View {
    @EnvironmentObject var context: Context
    @EnvironmentObject var system: GameSystem
    @ObservedObject var item: Record
    
    var body: some View {
        let label: String
        let isCustom: Bool

        if let itemType = item.prototype, let name = itemType.string(forKey: .name) {
            label = name
            isCustom = false
        } else if !context.editing, let name = item.string(forKey: .name) {
            label = name
            isCustom = true
        } else {
            label = "Custom:"
            isCustom = true
        }
        
        return HStack {
            if context.editing {
                ItemTypeMenu(action: handleSetType) {
                    Text(label)
                }
                                
                if isCustom {
                    StatView(sheet: item, key: .name)
                        .multilineTextAlignment(.leading)
                }
            } else {
                Text(label)
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
