// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

struct EditableIntegerView: View {
    @EnvironmentObject var context: Context
    @Binding var value: Int

    var body: some View {
        if context.editing {
            TextField("Name", text: stringValue)
                .multilineTextAlignment(.center)
                .background(Color.gray.opacity(0.1))
                .keyboardType(.numberPad)
                
        } else {
            Text(value, format: .number)
        }
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
