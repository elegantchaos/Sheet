// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import SwiftUI

struct InventoryItemView: View {
    @ObservedObject var item: CharacterItem
    
    var body: some View {
        HStack {
            Text(item.name ?? "<unknown item>")
            Text(Int(item.count), format: .number)
        }
    }
}

struct InventoryView: View {
    @ObservedObject var sheet: CharacterSheet
    
    var body: some View {
        return List {
            if let coerced = sheet.items as? Set<CharacterItem>, let items = Array(coerced) {
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
        let item = CharacterItem(context: sheet.managedObjectContext!)
        item.sheet = sheet
        item.name = "Untitled"
        item.count = 1
        try? sheet.save()
    }
    
    func handleDelete(_ items: IndexSet) {
        
    }
}
