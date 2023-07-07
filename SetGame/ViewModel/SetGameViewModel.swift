//
//  SetGameViewModel.swift
//  SetGame
//
//  Created by soylent on 6/3/23.
//

import Foundation

/// The view model.
class SetGameViewModel: ObservableObject {
    /// Vanilla Set card.
    typealias Card = SetGameModel<VanillaCardAttributes>.Card

    /// An instance of the game model.
    @Published var model: SetGameModel<VanillaCardAttributes>!
    /// An array of ids of the currently selected cards.
    @Published private var selectedCardIds: Set<Int> = []
    /// All available cards.
    var cards: [Card] { model.cards }
    /// The cards that have been discarded.
    var doneCards: [Card] { model.doneCards.reversed() }
    /// The cards that are currently in the deck.
    var remainingCards: [Card] { model.cardsBy(states: .deck) }
    /// The cards that are currently on the table.
    var visibleCards: [Card] { model.cardsBy(states: .unmatched, .matched, .mismatched) }

    /// Creates an instance of the view model.
    init() {
        startNewGame()
    }

    /// Selects the given `card` and updates the game state accordingly.
    func choose(card: Card) {
        if selectedCardIds.count >= model.setSize {
            selectedCardIds.removeAll()
            resetMismatchedCards()
        }

        toggle(card: card)
    }

    /// Flips the selection of the given `card` by updating `selectedCardIds`.
    private func toggle(card: Card) {
        guard card.state != .matched else { return }

        if selectedCardIds.contains(card.id) {
            selectedCardIds.remove(card.id)
        } else {
            selectedCardIds.insert(card.id)
        }
    }

    /// Ruturns true if the given `card` is currently selected.
    func isSelected(_ card: Card) -> Bool {
        selectedCardIds.contains(card.id)
    }

    /// Deselects all currently selected cards.
    func deselectAllCards() {
        selectedCardIds.removeAll()
    }

    /// Checks if the currently selected cards form a matching set.
    func tryToMatchSelectedCards() {
        model.tryToMatchCards(withIds: selectedCardIds)
    }

    /// Removes matched cards from the table.
    func discardMatchedCards(withReplacement: Bool = false) -> Int {
        let matchedCount = model.changeCardState(from: .matched, to: .done)
        if withReplacement {
            model.dealCards(numberOfCards: matchedCount)
        }
        return matchedCount
    }

    /// Resets any mismatched cards.
    func resetMismatchedCards() {
        let _ = model.changeCardState(from: .mismatched, to: .unmatched)
    }

    /// Adds more cards to the table.
    func dealCards() {
        model.dealCards(numberOfCards: VanillaCardAttributes.additionalDealingSize)
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
