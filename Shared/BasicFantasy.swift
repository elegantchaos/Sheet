//
//  BasicFantasyRPG.swift
//  Sheet (iOS)
//
//  Created by Sam Deane on 13/07/2021.
//  Copyright © 2021 Elegant Chaos. All rights reserved.
//

import Foundation
import UIKit

struct BasicFantasy {
    enum Detail: String, CaseIterable, Identifiable {
        case race
        case gender
        case level
        case age
        case hits
        case damage
        
        var id: String {
            rawValue
        }
    }
}
