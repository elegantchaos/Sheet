// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 16/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import SwiftUI


struct EditableStatView: View {
    @EnvironmentObject var context: Context
    @ObservedObject var sheet: CharacterSheet
    let key: GameSystem.Stat
    
    var body: some View {
        let isEditable = context.editing && !key.isCalculated
        if isEditable, let binding = sheet.binding(forKey: key) {
            StatView(value: binding)
        } else if let stat = sheet.stat(forKey: key) {
            StatView(value: stat)
        } else {
            Text("no value for \(key.rawValue)")
        }
    }
}
