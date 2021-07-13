// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

struct StatsView: View {
    @ObservedObject var sheet: CharacterSheet

    static let statFormatter =
    IntegerFormatStyle()
        .sign(strategy: .always(includingZero: false))

    var body: some View {
        VStack {
            LazyVGrid(columns: [GridItem(.fixed(128)), GridItem(.fixed(32)), GridItem(.fixed(32))]) {
                ForEach(Stat.Kind.allCases) { kind in
                    let stat = Stat(sheet: sheet, kind: kind)

                    HStack {
                        Spacer()
                        Text(stat.label)
                    }

                    Text(stat.valueString)
                    
                    if stat.modifier != 0 {
                        Text(stat.modifier, format: Self.statFormatter)
                            .font(.footnote)
                    } else {
                        Text("")
                    }
                }
            }
        }
    }
}
