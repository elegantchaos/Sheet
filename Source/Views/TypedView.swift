// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 16/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import SwiftUI

struct TypedView: View {
    let value: Any?
    let placeholder: String
    
    init(value: Any?, placeholder: Any? = nil) {
        self.value = value
        if let placeholder = placeholder {
            self.placeholder = String(describing: placeholder)
        } else {
            self.placeholder = ""
        }
    }
    
    var body: some View {
        switch value {
            case is String:
                Text(value as! String)
                
            case is Int:
                Text(value as! Int, format: .number)

            case is Double:
                Text(value as! Double, format: .number)

            case is Binding<String>:
                EditableStringView(value: value as! Binding<String>, placeholder: placeholder)

            case is Binding<Int>:
                EditableIntegerView(value: value as! Binding<Int>, placeholder: placeholder)

            case is Binding<Double>:
                EditableDoubleView(value: value as! Binding<Double>, placeholder: placeholder)

            case let carried as WeightCarried:
                WeightCarriedView(carried: carried)
                
            default:
                Text("<\(unknownTypeLabel)>")
        }
    }
    
    var unknownTypeLabel: String {
        if let value = value {
            return String(describing: type(of: value))
        } else {
            return "nil"
        }
    }
}
