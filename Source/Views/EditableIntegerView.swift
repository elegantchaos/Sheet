// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

struct EditableIntegerView: View {
    @Binding var value: Int
    let placeholder: String

    var body: some View {
        TextField(placeholder, text: stringValue)
            .multilineTextAlignment(.center)
            .background(Color.gray.opacity(0.1))
            .keyboardType(.numberPad)
    }
    
    var stringValue: Binding<String> {
        return Binding<String>(
            get: { String(value) },
            set: { newValue in
                if let integer = Int(newValue) {
                    value = integer
                }
            }
        )
    }
}
