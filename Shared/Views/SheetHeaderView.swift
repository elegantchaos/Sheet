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
    @EnvironmentObject var system: GameSystem
    @ObservedObject var sheet: CharacterSheet
    
    var body: some View {
        let keys = system.topStats
        return LazyVGrid(columns: [GridItem](repeating: GridItem(.flexible()), count: keys.count)) {
            ForEach(keys) { key in
                Text(LocalizedStringKey(key.rawValue))
            }

            ForEach(keys) { key in
                if key.isCalculated {
                    if let string = sheet.string(forKey: key) {
                        Text(string)
                    } else if let integer = sheet.integer(forKey: key) {
                        Text("\(integer)")
                    }
                } else {
                    if let _ = sheet.string(forKey: key) {
                        EditableStringView(value: sheet.editableString(forKey: key))
                    } else {
                        EditableIntegerView(value: sheet.editableInteger(forKey: key))
                    }
                }
            }
            .font(.body.weight(.bold))
        }
    }
}
