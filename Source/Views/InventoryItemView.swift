// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 16/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Records
import SwiftUI

struct InventoryItemView: View {
    @EnvironmentObject var context: Context
    @ObservedObject var item: Record
    @State var showItemEditor = false
    
    var body: some View {
        let count = item.integer(forKey: .itemCount) ?? 0
        return HStack {
            ItemStatusMenu(item: item)
                .frame(width: 20)

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
            Text(weight, format: .number.precision(.fractionLength(1)))
            
//            if context.editing {
                Label("Edit", systemImage: "ellipsis")
                    .onTapGesture(perform: handleEdit)
                    .sheet(isPresented: $showItemEditor) {
                        InventoryItemEditorView(item: item)
                            .padding()
                    }
//            }
            
//            let status = ItemStatus(rawValue: item.integer(forKey: .itemStatus) ?? 0) ?? .recorded
//            Image(systemName: status.imageName)
//                .onTapGesture(perform: handleToggleStatus)
        }
        .controlSize(.mini)
        .labelStyle(.iconOnly)
    }
    
    func handleEdit() {
        showItemEditor = true
    }
    
    func handleToggleStatus() {
        let newStatus: ItemStatus
        if let current = item.integer(forKey: .itemStatus), let new = ItemStatus(rawValue: current + 1) {
            newStatus = new
        } else {
            newStatus = .recorded
        }
        item.set(newStatus.rawValue, forKey: .itemStatus)
        print("Updated status for \(item)")
    }
}

struct ItemStatusMenu: View {
    @ObservedObject var item: Record

    var body: some View {
        Menu {
            ForEach(ItemStatus.allCases) { status in
                Button(action: { handleSetStatus(status) }) {
                    HStack {
                        Image(systemName: status.imageName)
                        Text(status.label)
                    }
                }
            }
        } label: {
            let status = ItemStatus(rawValue: item.integer(forKey: .itemStatus) ?? 0) ?? .recorded
            Image(systemName: status.imageName)
        }
        .menuStyle(.borderlessButton)
        .menuIndicator(.visible)
    }
    
    func handleSetStatus(_ status: ItemStatus) {
        item.set(status.rawValue, forKey: .itemStatus)
    }
}
