// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 21/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import Records
import SwiftUI

struct SheetHeaderView: View {
    @EnvironmentObject var context: Context
    @EnvironmentObject var system: GameSystem
    @ObservedObject var sheet: Record
    
    var body: some View {
        let keys =  context.editing ? system.topStatsEditing : system.topStatsViewing
        return LazyVGrid(columns: [GridItem](repeating: GridItem(.flexible()), count: keys.count)) {
            ForEach(keys) { key in
                Text(LocalizedStringKey(key.rawValue))
            }

            ForEach(keys) { key in
                StatView(sheet: sheet, key: key)
                    .multilineTextAlignment(.center)
            }
            .font(.body.weight(.bold))
        }
    }
}
