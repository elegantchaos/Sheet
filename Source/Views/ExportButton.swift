// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import Records
import SwiftUI
import UniformTypeIdentifiers


struct CharacterSheetExportSheet: ViewModifier {
    let sheet: Record
    @EnvironmentObject var context: Context

    func body(content: Content) -> some View {
        content
            .fileExporter(isPresented: $context.showExportSheet, document: sheet.asJSONFile, contentType: .json, defaultFilename: sheet.jsonExportName, onCompletion: sheet.handleExported)

    }
}

extension View {
    func exportSheet(for sheet: Record) -> some View {
        self
            .modifier(CharacterSheetExportSheet(sheet: sheet))
    }
}

struct ExportButton: View {
    @EnvironmentObject var context: Context

    var body: some View {
        Button(action: handleShare) {
            Label("Share", systemImage: "square.and.arrow.up")
        }
    }

    func handleShare() {
        context.showExportSheet = true
    }
    
}
