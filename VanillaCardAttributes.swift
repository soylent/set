//
//  VanillaCardAttributes.swift
//  SetGame
//
//  Created by user on 6/5/23.
//

import Foundation

/// Attributes of a single Set card.
///
/// The game can be extended to support other card appearances, attributes, set sizes, etc.
struct VanillaCardAttributes: SetMatchable {
    /// The number of cards that can form a set.
    static let setSize = 3
    /// The initial number of cards on the table.
    static let initialDealingSize = 12
    /// The number of cards in a deck.
    static let deckSize = 3 * 3 * 3 * 3
    /// The number of additional cards that can be drawn.
    static let additionalDealingSize = 3

    /// An array of all possible attribute combinations.
    static var allCardAttributeCombinations: [Self] {
        var combinations: [Self] = []
        for number in Number.allCases {
            for symbol in Symbol.allCases {
                for shading in Shading.allCases {
                    for color in Color.allCases {
                        combinations.append(
                            Self(number: number, symbol: symbol, shading: shading, color: color)
                        )
                    }
                }
            }
        }
        assert(combinations.count == deckSize)
        return combinations
    }

    /// The number of symbols on the face of the card.
    var number: Number
    /// The symbol shown on the face of the card.
    var symbol: Symbol
    /// The shading applied to the card symbol(s).
    var shading: Shading
    /// The color of the card symbol(s).
    var color: Color
    /// An array that represents the card attributes.
    var rawAttributes: [Int] { [number.rawValue, symbol.rawValue, shading.rawValue, color.rawValue] }

    /// Symbol count.
    enum Number: Int, CaseIterable {
        case one = 1, two, three
    }
    /// Symbol types.
    enum Symbol: Int, CaseIterable {
        case diamond, squiggle, oval
    }
    /// Shading types.
    enum Shading: Int, CaseIterable {
        case solid, striped, open
    }
    /// Symbol colors.
    enum Color: Int, CaseIterable {
        case red, green, purple
    }
}
