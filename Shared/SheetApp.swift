//
//  SheetApp.swift
//  Shared
//
//  Created by Sam Deane on 13/07/2021.
//

import SwiftUI

@main
struct SheetApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
