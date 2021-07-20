// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var system: GameSystem
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [],
        predicate: NSPredicate(format: "parent == nil"),
        animation: .default)
    private var items: FetchedResults<Record>
    
    var body: some View {
        if items.count > 0, let sheet = items.first(where: { !$0.id.starts(with: "item-") }) {
            SheetView(sheet: sheet)
                .padding()
        } else {
            Button(action: handleNewSheet) {
                Text("New Sheet")
            }
        }
    }
    
    func handleNewSheet() {
        let record = Record(context: viewContext)
        system.randomize(sheet: record)
        try? record.save()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
