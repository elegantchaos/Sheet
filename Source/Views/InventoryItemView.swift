// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 16/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

struct InventoryItemView: View {
    @EnvironmentObject var context: Context
    @ObservedObject var item: Record
    
    var body: some View {
        HStack {
            ItemTypeView(item: item)
//            EditableStatView(sheet: item, key: .itemType)

            Spacer()

            if context.editing || (item.integer(forKey: .itemCount) ?? 0) > 1 {
                Text("×")
                EditableStatView(sheet: item, key: .itemCount)
            }

            if context.editing {
                EditableStatView(sheet: item, key: .itemWeight)
                EditableStatView(sheet: item, key: .itemEquipped)
            }
        }
    }
}
