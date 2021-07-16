// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/07/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

protocol GameRules {
    associatedtype Stat
    associatedtype CharacterClass
    associatedtype SavingThrow
    
    init(savingThrows: SavingThrowTable)
    
    var topStatsViewing: [Stat] { get }
    var abilityStats: [Stat] { get }
}
