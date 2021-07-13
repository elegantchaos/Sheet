// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

@main
struct SheetApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        let url = Bundle.main.url(forResource: "SavingThrows", withExtension: "json")
        let savingThrows = try! SavingThrowTable(url: url!)

        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(savingThrows)
        }
    }
}
