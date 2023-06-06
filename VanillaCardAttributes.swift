//
//  VanillaCardAttributes.swift
//  SetGame
//
//  Created by user on 6/5/23.
//

import Foundation

struct VanillaCardAttributes: SetMatchable {
    static let setSize = 3
    static let initialDealingSize = 12
    static let deckSize = 3 * 3 * 3 * 3
    static let additionalDealingSize = 3

    static var allCards: [VanillaCardAttributes] {
        var cards: [VanillaCardAttributes] = []
        for number in Number.allCases {
            for symbol in Symbol.allCases {
                for shading in Shading.allCases {
                    for color in Color.allCases {
                        cards.append(VanillaCardAttributes(number: number, symbol: symbol, shading: shading, color: color))
                    }
                }
            }
        }
        assert(cards.count == deckSize)
        return cards
    }

    var number: Number
    var symbol: Symbol
    var shading: Shading
    var color: Color

    var rawAttributes: [Int] { [number.rawValue, symbol.rawValue, shading.rawValue, color.rawValue] }

    enum Number: Int, CaseIterable {
        case one = 1, two, three
    }
    enum Symbol: Int, CaseIterable {
        case diamond, squiggle, oval
    }
    enum Shading: Int, CaseIterable {
        case solid, striped, open
    }
    enum Color: Int, CaseIterable {
        case red, green, purple
    }
}
