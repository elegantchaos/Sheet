// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 16/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Records
import SwiftUI

struct InventoryItemView: View {
    @EnvironmentObject var context: Context
    @ObservedObject var item: Record
    
    var body: some View {
        let count = item.integer(forKey: .itemCount) ?? 0
        return HStack {
            if context.editing || count > 1 {
                StatView(sheet: item, key: .itemCount)
                Text("×")
            }

            ItemTypeView(item: item)
//            EditableStatView(sheet: item, key: .itemType)

            Spacer()


            let weight = item.double(forKey: .itemWeight) ?? 0.0
            let entryWeight = weight * Double(count)
            Text(entryWeight, format: .number)

            if context.editing {
                StatView(sheet: item, key: .itemWeight)
                StatView(sheet: item, key: .itemEquipped)
            }
        }
    }
}
