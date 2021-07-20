// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import SwiftUI


struct InventoryView: View {
    @EnvironmentObject var context: Context
    @EnvironmentObject var system: GameSystem
    @ObservedObject var sheet: Record
    
    var body: some View {
        return List {
            Section {
                if let items = sheet.stat(forKey: .items) as? Set<Record>, let sorted = Array(items) {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(sorted) { item in
                            InventoryItemView(item: item)
                                .listRowSeparator(.hidden)
                                .listRowInsets(.init(top: 0, leading: 32, bottom: 0, trailing: 0))
                        }
                        .onDelete(perform: handleDelete)
                    }
                }
            } header: {
                HStack {
                    Text("Inventory")
                    if context.editing {
                        Spacer()
                        ItemTypeMenu(action: handleAddItem) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
        
        #if os(macOS)
        .listStyle(.inset(alternatesRowBackgrounds: true))
        #else
        .listStyle(.plain)
        #endif
    }

    func handleAddItem(_ id: String?) {
        let item = Record(context: sheet.managedObjectContext!)
        item.set("Untitled Item", forKey: .name)
        item.set(1, forKey: .itemCount)
        sheet.append(item, forKey: .items)
        system.randomize(item: item)
        try? sheet.save()
    }
    
    func handleDelete(_ items: IndexSet) {
        
    }
}
