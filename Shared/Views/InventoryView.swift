// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import SwiftUI

struct InventoryItemView: View {
    @ObservedObject var item: Record
    
    var body: some View {
        HStack {
            EditableStatView(sheet: item, key: .name)
            EditableStatView(sheet: item, key: .itemCount)
        }
    }
}

struct InventoryView: View {
    @ObservedObject var sheet: Record
    
    var body: some View {
        return List {
            if let items = sheet.stat(forKey: .items) as? Set<Record>, let sorted = Array(items) {
                ForEach(sorted) { item in
                    InventoryItemView(item: item)
                }
                .onDelete(perform: handleDelete)
            }
            
            Button(action: handleAddItem) {
                Text("Add Item")
            }
        }
        #if os(macOS)
        .listStyle(.inset(alternatesRowBackgrounds: true))
        #else
        .listStyle(.plain)
        #endif
    }

    func handleAddItem() {
        let item = Record(context: sheet.managedObjectContext!)
        item.set("Untitled Item", forKey: .name)
        item.set(1, forKey: .itemCount)
        sheet.append(item, forKey: .items)
        try? sheet.save()
    }
    
    func handleDelete(_ items: IndexSet) {
        
    }
}
