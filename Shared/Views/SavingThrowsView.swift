// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

struct SavingThrowsView: View {
    @ObservedObject var sheet: CharacterSheet
    @EnvironmentObject var savingThrows: SavingThrowTable

    static let statFormatter =
    IntegerFormatStyle()
        .sign(strategy: .always(includingZero: false))
    
    var body: some View {
        VStack {
            if let cclass = sheet.characterClass, let level = sheet.integer(forKey: .level) {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.fixed(24))]) {
                    ForEach(BasicFantasy.SavingThrow.allCases) { savingThrow in
                        if let value = savingThrows.value(for: savingThrow, class: cclass, level: level) {
                            HStack {
                                Spacer()
                                Text(savingThrow.label)
                            }
                            Text(value, format: .number)
                                .bold()
                        }
                    }
                }
            }
        }
    }
}

