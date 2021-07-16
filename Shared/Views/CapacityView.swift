//
//  CapacityView.swift
//  CapacityView
//
//  Created by Sam Deane on 16/07/2021.
//  Copyright © 2021 Elegant Chaos. All rights reserved.
//

import Foundation
import SwiftUI

struct CapacityView: View {
    let capacity: CharacterSheet.Capacity
    
    var body: some View {
        HStack {
            Text(capacity.value, format: .number)
            if capacity.status != .normal {
                Image(systemName: "exclamationmark.triangle")
                    .foregroundColor(capacity.status.color)
            }
        }
    }
}
