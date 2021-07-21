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
            if context.editing {
                Stepper(value: item.integerBinding(forKey: .itemCount)) {
                    Text("")
                }
                .labelsHidden()

                StatView(sheet: item, key: .itemCount)
                    .frame(maxWidth: 64.0)
            } else {
                Text(count, format: .number)
            }
            

            Text("×")

            ItemTypeView(item: item)
//            EditableStatView(sheet: item, key: .itemType)

            Spacer()


            let weight = item.double(forKey: .itemTotalWeight) ?? 0
            Text(weight, format: .number)

            if context.editing {
                StatView(sheet: item, key: .itemWeight)
                StatView(sheet: item, key: .itemEquipped)
            }
        }
        .controlSize(.mini)
    }
}
