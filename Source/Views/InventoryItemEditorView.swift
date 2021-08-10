// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Records
import SwiftUI

struct InventoryItemEditorView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var item: Record
    
    var body: some View {
        VStack {
            StatView(sheet: item, key: .name)

            if let prototype = item.prototype, let name = prototype.string(forKey: .name) {
                Text("Based on \(name).")
            }
            
            Spacer()

            Button(action: handleDismiss) {
                Text("Done")
            }
        }
    }
    
    func handleDismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}
