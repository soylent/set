//
//  SetGameViewModel.swift
//  SetGame
//
//  Created by user on 6/3/23.
//

import Foundation

/// The view model.
class SetGameViewModel: ObservableObject {
    /// Vanilla Set card.
    typealias Card = SetGameModel<VanillaCardAttributes>.Card

    /// An instance of the game model.
    @Published var model: SetGameModel<VanillaCardAttributes>!

    /// The cards that are currently on the table.
    var visibleCards: [Card] { model.cardsBy(states: .unmatched, .matched, .mismatched) }
    /// Whether or not the deck is empty.
    var deckIsEmpty: Bool { model.cardsBy(states: .deck).isEmpty }

    /// Creates an instance of the view model.
    init() {
        startNewGame()
    }

    // MARK: - Intents

    /// Selects the given `card` and updates the game state accordingly.
    func choose(_ card: Card) {
        model.choose(card)
    }

    /// Adds more cards to the table.
    func dealMoreCards() {
        let _ = model.cleanUpMatchedCards()
        model.dealMoreCards(numberOfCards: VanillaCardAttributes.additionalDealingSize)
    }

    /// Resets the game.
    func startNewGame() {
        model = SetGameModel(
            cardAttributes: VanillaCardAttributes.allCardAttributeCombinations,
            setSize: VanillaCardAttributes.setSize,
            initialDealingSize: VanillaCardAttributes.initialDealingSize
        )
    }
}
