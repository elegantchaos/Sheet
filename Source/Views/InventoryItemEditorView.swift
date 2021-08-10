// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Records
import SwiftUI

struct InventoryItemEditorView: View {
    @EnvironmentObject var context: Context
    @ObservedObject var item: Record
    
    var body: some View {
        VStack {
            StatView(sheet: item, key: .name)

            Spacer()

            Button(action: { context.itemToEdit = nil }) {
                Text("Done")
            }
        }
    }
}
