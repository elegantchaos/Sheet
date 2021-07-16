// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 16/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import SwiftUI

struct WeightCarried {
    enum Status {
        case normal
        case encumbered
        case overloaded
        
        var color: Color {
            switch self {
                case .normal: return .green
                case .encumbered: return .orange
                case .overloaded: return .red
            }

        }
    }

    let amount: Int
    let status: Status
}
