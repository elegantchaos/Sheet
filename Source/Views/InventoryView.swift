// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import Records
import SwiftUI


struct InventoryView: View {
    @EnvironmentObject var context: Context
    @EnvironmentObject var system: GameSystem
    @ObservedObject var sheet: Record
    
    var body: some View {
        return List {
            Section {
                if let sorted = sortedItems {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(sorted) { item in
                            InventoryItemView(item: item)
                                .listRowSeparator(.hidden)
                                .listRowInsets(.init(top: 0, leading: 32, bottom: 0, trailing: 0))
                                .id(item.id)
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

    var sortedItems: [Record]? {
        guard let items = sheet.stat(forKey: .items) as? Set<Record> else { return nil }
        let sorted = items.sorted(by: { $0.sortName < $1.sortName })
        print(sorted.map { $0.sortName })
        return sorted
    }
    
    func handleAddItem(_ id: String?) {
        let item = Record(context: sheet.managedObjectContext!)
        item.set(1, forKey: .itemCount)
        if let typeID = id, let itemType = system.itemIndex.item(withID: typeID) {
            item.prototype = itemType
        } else {
            item.prototype = nil
        }

        sheet.append(item, forKey: .items)
        try? sheet.save()
    }
    
    func handleDelete(_ items: IndexSet) {
        
    }
}
