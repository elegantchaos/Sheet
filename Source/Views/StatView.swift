// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 16/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import SwiftUI
import Records

struct StatView: View {
    @EnvironmentObject var context: Context
    @ObservedObject var sheet: Record
    let key: GameSystem.Stat
    
    var body: some View {
        let isEditable = context.editing && !key.isCalculated
        if isEditable, let binding = sheet.binding(forKey: key) {
            TypedView(value: binding, placeholder: sheet.prototype?.stat(forKey: key))
        } else if let stat = sheet.stat(forKey: key) {
            TypedView(value: stat)
        } else {
            Image(systemName: "exclamationmark.triangle")
                .accessibilityHint("no value for \(key.rawValue)")
        }
    }
}
