// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

struct SheetView: View {
    @ObservedObject var sheet: CharacterSheet
    
    var body: some View {
        Text(sheet.name!)
        
        ForEach(Stat.Kind.allCases) { kind in
            let stat = Stat(sheet: sheet, kind: kind)
            HStack {
                Label(stat.label, systemImage: "tag")
                Text(stat.valueString)
                Text(stat.modifierString)
            }
        }
    }
}
