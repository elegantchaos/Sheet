// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

struct AbilitiesView: View {
    @ObservedObject var sheet: CharacterSheet
    @EnvironmentObject var system: GameSystem
    
    static let statFormatter =
    IntegerFormatStyle()
        .sign(strategy: .always(includingZero: false))

    var body: some View {
        VStack {
            LazyVGrid(columns: [GridItem(.fixed(128)), GridItem(.fixed(24)), GridItem(.fixed(24))]) {
                ForEach(system.abilityStats) { ability in
                    HStack {
                        Spacer()
                        Text(ability.label)
                    }

                    EditableIntegerView(value: sheet.editableInteger(forKey: ability))
                        .font(.body.weight(.bold))

                    Text(sheet.modifier(for: ability))
                        .font(.footnote)
                }
            }
        }
    }
}
