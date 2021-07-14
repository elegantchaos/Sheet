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
        let url = Bundle.main.url(forResource: "SavingThrows", withExtension: "json")
        let savingThrows = try! SavingThrowTable(url: url!)
        let system = BasicFantasy(savingThrows: savingThrows)

        self.system = system
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
