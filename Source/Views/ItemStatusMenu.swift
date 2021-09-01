// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 31/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Records
import SwiftUI

struct ItemStatusMenu: View {
    @ObservedObject var item: Record

    var body: some View {
        Menu {
            ForEach(ItemStatus.allCases) { status in
                Button(action: { handleSetStatus(status) }) {
                    HStack {
                        Image(systemName: status.imageName)
                        Text(status.label)
                    }
                }
            }
        } label: {
            let status = ItemStatus(rawValue: item.integer(forKey: .itemStatus) ?? 0) ?? .recorded
            Image(systemName: status.imageName)
        }
        .menuStyle(.borderlessButton)
        .menuIndicator(.visible)
    }
    
    func handleSetStatus(_ status: ItemStatus) {
        item.set(status.rawValue, forKey: .itemStatus)
    }
}
