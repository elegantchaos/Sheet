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
                HStack {
                    Spacer()
                    Text(count, format: .number)
                }
                .frame(width: 48.0)
            }
            
            Text("×")

            ItemTypeView(item: item)

            Spacer()

            let weight = item.double(forKey: .itemTotalWeight) ?? 0
            Text(weight, format: .number.precision(.fractionLength(2)))

            if context.editing {
//                Button(action: handleEdit) {
                    Label("Edit", systemImage: "ellipsis")
                        .onTapGesture {
                            handleEdit()
                        }
//                }
            }
        }
        .controlSize(.mini)
        .labelStyle(.iconOnly)
    }
    
    var itemForEditing: Record {
        return item.prototype ?? item
    }
    
    func handleEdit() {
        if context.itemToEdit == nil {
            print("editing \(item.id)")
            context.itemToEdit = item.prototype ?? item
        }
    }
}
