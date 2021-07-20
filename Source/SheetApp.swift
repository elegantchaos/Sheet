// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

typealias GameSystem = BasicFantasy

@main
struct SheetApp: App {
    let persistenceController = PersistenceController.shared
    let context = Context()
    let system: GameSystem
    
    init() {
        let savingThrows = try! SavingThrowTable()
        let items = try! ItemIndex()
        let system = BasicFantasy(savingThrows: savingThrows, itemIndex: items)

        self.system = system
        
        items.update(container: persistenceController.container)
    }
    
    var body: some Scene {

        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(context)
                .environmentObject(system)
        }
    }
}
