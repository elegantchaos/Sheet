// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

struct IndexView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("selection") var selection: String?
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    
    private var items: FetchedResults<Record>
    
    var body: some View {
        NavigationView {
            VStack {
                List(selection: $selection) {
                    ForEach(items) { sheet in
                        NavigationLink(destination: SheetView(sheet: sheet), tag: sheet.id, selection: $selection) {
                            Text(sheet.string(forKey: .name)!)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                
                Text(selection ?? "<none>")
            }
        }
        .toolbar {
#if os(iOS)
            EditButton()
#endif
            
            Button(action: addItem) {
                Label("Add Item", systemImage: "plus")
            }
        }
        
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Record(context: viewContext)
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
