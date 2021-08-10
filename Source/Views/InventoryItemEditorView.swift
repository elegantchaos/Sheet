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

            if let name = item.prototype?.string(forKey: .name) {
                Text("Based on \(name).")
            }
            
            Spacer()

            let props: [GameSystem.Stat] = [.name, .itemCount, .itemWeight, .itemEquipped, .itemGuidePrice]
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(props) { prop in
                    HStack {
                        Spacer()
                        Text(prop.rawValue)
                    }

                    StatView(sheet: item, key: prop)
                }
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
