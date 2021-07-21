// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI
import Records

struct SavingThrowsView: View {
    @ObservedObject var sheet: Record
    @EnvironmentObject var system: GameSystem
    
    static let statFormatter =
    IntegerFormatStyle()
        .sign(strategy: .always(includingZero: false))
    
    var body: some View {
        VStack {
            if let cclass = sheet.characterClass, let level = sheet.integer(forKey: .level), let race = sheet.string(forKey: .race) {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.fixed(24))]) {
                    ForEach(BasicFantasy.SavingThrow.allCases) { savingThrow in
                        if let value = system.savingThrowValue(for: savingThrow, class: cclass, race: race, level: level) {
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

