// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 31/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

enum ItemStatus: Int, Identifiable, CaseIterable {
    case recorded   // recorded on the sheet, but not contributing to encumberance (eg stored elsewhere)
    case carried    // contributing to encumberance
    case equipped   // contributing to encumberance, protection, etc
    case primary    // main weapon
    case secondary  // secondary (off-hand) weapon
    case ranged     // main ranged weapon
    case dual       // dual-weild weapon
    
    var imageName: String {
        switch self {
            case .recorded: return "tag"
            case .carried: return "bag"
            case .primary: return "circle.tophalf.fill"
            case .secondary: return "circle.bottomhalf.fill"
            case .dual: return "circle.fill"
            case .ranged: return "line.diagonal.arrow"
            case .equipped: return "person"
        }
    }
    
    var id: Int {
        return rawValue
    }
    
    var label: String {
        switch self {
            case .recorded: return "Owned"
            case .carried: return "Carried"
            case .primary: return "Main Weapon"
            case .secondary: return "Off-hand Weapon"
            case .dual: return "Dual Weapon"
            case .ranged: return "Ranged Weapon"
            case .equipped: return "Equipped"
        }
    }
}
