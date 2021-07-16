//
//  SheetHeaderView.swift
//  SheetHeaderView
//
//  Created by Sam Deane on 15/07/2021.
//  Copyright © 2021 Elegant Chaos. All rights reserved.
//

import Foundation
import SwiftUI

struct SheetHeaderView: View {
    @EnvironmentObject var context: Context
    @EnvironmentObject var system: GameSystem
    @ObservedObject var sheet: CharacterSheet
    
    var body: some View {
        let keys =  context.editing ? system.topStatsEditing : system.topStats
        return LazyVGrid(columns: [GridItem](repeating: GridItem(.flexible()), count: keys.count)) {
            ForEach(keys) { key in
                Text(LocalizedStringKey(key.rawValue))
            }

            ForEach(keys) { key in
                EditableStatView(sheet: sheet, key: key)
            }
            .font(.body.weight(.bold))
        }
    }
}
