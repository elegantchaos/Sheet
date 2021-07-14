// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

struct EditableStringView: View {
    @EnvironmentObject var context: Context
    @Binding var value: String

    var body: some View {
        if context.editing {
            TextField("Name", text: $value)
                .multilineTextAlignment(.center)
                .background(Color.gray.opacity(0.1))
        } else {
            Text(value)
        }
    }
}
