// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 19/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import SwiftUI

struct ItemTypeMenu<Label>: View where Label:View  {
    @EnvironmentObject var system: GameSystem

    let action: (String?) -> ()
    @ViewBuilder let label: Label
    
    var body: some View {
        let items = system.itemIndex
        return Menu {
            Button(action: { action(nil) } ) {
                Text("Custom")
            }

            Divider()
            
            ForEach(items.itemIds, id: \.self) { itemID in
                if let item = items.item(withID: itemID) {
                    Button(action: { action(itemID) }) {
                        Text(item.name)
                    }
                }
            }
        } label: {
            label
        }
    }
}
