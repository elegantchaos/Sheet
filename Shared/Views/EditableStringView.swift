// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

struct EditableStringView: View {
    @Binding var value: String

    var body: some View {
        TextField("Name", text: $value)
            .background(Color.gray.opacity(0.1))
            .autocapitalization(.none)
            .disableAutocorrection(true)
    }
}
