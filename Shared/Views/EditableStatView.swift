// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 16/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import SwiftUI

struct StatView: View {
    let value: Any?
    
    var body: some View {
        switch value {
            case is String:
                Text(value as! String)
                
            case is Int:
                Text(value as! Int, format: .number)

            case is Binding<String>:
                EditableStringView(value: value as! Binding<String>)

            case is Binding<Int>:
                EditableIntegerView(value: value as! Binding<Int>)
                
            default:
                EmptyView()
        }
    }
}

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
        }
    }
}
