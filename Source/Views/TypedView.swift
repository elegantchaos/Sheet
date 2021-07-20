// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 16/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import SwiftUI

struct TypedView: View {
    let value: Any?
    
    var body: some View {
        switch value {
            case is String:
                Text(value as! String)
                
            case is Int:
                Text(value as! Int, format: .number)

            case is Binding<String>:
                EditableStringView(value: value as! Binding<String>)

            case is Binding<Int>:
                EditableIntegerView(value: value as! Binding<Int>)
                
            case let carried as WeightCarried:
                WeightCarriedView(carried: carried)
                
            default:
                Text("<unknown type>")
        }
    }
}
