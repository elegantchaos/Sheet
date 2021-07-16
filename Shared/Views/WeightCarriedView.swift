// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 16/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import SwiftUI

struct WeightCarriedView: View {
    let carried: WeightCarried
    
    var body: some View {
        HStack {
            Text(carried.amount, format: .number)
            if carried.status != .normal {
                Image(systemName: "exclamationmark.triangle")
                    .foregroundColor(carried.status.color)
            }
        }
    }
}
