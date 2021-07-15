// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import SwiftUI

struct InventoryItemView: View {
    @ObservedObject var item: CharacterSheet
    
    var body: some View {
        HStack {
            EditableStringView(value: item.editableString(forKey: .name))
            EditableIntegerView(value: item.editableInteger(forKey: "count"))
        }
    }
}

struct InventoryView: View {
    @ObservedObject var sheet: CharacterSheet
    
    var body: some View {
        return List {
            if let coerced = sheet.items as? Set<CharacterSheet>, let items = Array(coerced) {
                ForEach(items) { item in
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
        let item = CharacterSheet(context: sheet.managedObjectContext!)
        item.parent = sheet
        item.set("Untitled Item", forKey: .name)
        item.set(1, forKey: "count")
        try? sheet.save()
    }
    
    func handleDelete(_ items: IndexSet) {
        
    }
}
