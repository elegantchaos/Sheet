// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import Records
import SwiftUI
import UniformTypeIdentifiers

// TODO: turn this into a generic manager for shareable things?

class ExportManager: ObservableObject {
    @Published var showExportSheet = false
    
    func handleShowSheet() {
        showExportSheet = true
    }
}

struct ExportButton: View {
    @EnvironmentObject var manager: ExportManager

    var body: some View {
        Button(action: manager.handleShowSheet) {
            Label("Share", systemImage: "square.and.arrow.up")
        }
    }
}

struct ExportViewModifier: ViewModifier {
    let sheet: Record
    @EnvironmentObject var manager: ExportManager

    func body(content: Content) -> some View {
        content
            .fileExporter(isPresented: $manager.showExportSheet, document: JSONFile(provider: sheet), contentType: .json, defaultFilename: sheet.jsonExportName, onCompletion: sheet.handleExported)

    }
}

extension View {
    func exportSheet(for sheet: Record) -> some View {
        self
            .modifier(ExportViewModifier(sheet: sheet))
    }
}

