//
//  SetGameViewModel.swift
//  SetGame
//
//  Created by user on 6/3/23.
//

import Foundation

class SetGameViewModel: ObservableObject {
    typealias Card = SetGameModel<VanillaCardAttributes>.Card

    @Published var model: SetGameModel<VanillaCardAttributes>

    var visibleCards: [Card] { model.cardsBy(states: .unmatched, .matched, .mismatched) }
    var deckIsEmpty: Bool { model.cardsBy(states: .deck).isEmpty }

    init() {
        model = SetGameModel(
            numberOfCards: VanillaCardAttributes.deckSize,
            setSize: VanillaCardAttributes.setSize,
            initialDealingSize: VanillaCardAttributes.initialDealingSize,
            cardAttributes: VanillaCardAttributes.allCards
        )
    }

    // MARK: - Intents

    func choose(_ card: Card) {
        model.choose(card)
    }

    func dealMoreCards() {
        model.dealMoreCards(count: VanillaCardAttributes.additionalDealingSize)
    }
}
