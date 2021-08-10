// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import SwiftUI

struct ConfirmedButton<V>: View where V: View {
    let role: ButtonRole?
    let label: String
    let image: String
    let confirmation: String
    @ViewBuilder let actions: () -> V

    init(role: ButtonRole? = nil, label: String, image: String, confirmation: String, actions: @escaping () -> V) {
        self.role = role
        self.label = label
        self.image = image
        self.confirmation = confirmation
        self.actions = actions
    }

    @State var showConfirmation = false
    
    var body: some View {
        Button(role: role) {
            showConfirmation = true
        } label: {
            Label(label, systemImage: image)
        }
        .confirmationDialog(confirmation, isPresented: $showConfirmation, actions: actions)
    }
}
