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
    /// The cards that are currently in the deck.
    var remainingCards: [Card] { model.cardsBy(states: .deck) }
    /// The cards that have been discarded.
    var doneCards: [Card] { model.cardsBy(states: .done) }

    /// Creates an instance of the view model.
    init() {
        startNewGame()
    }

    /// Selects the given `card` and updates the game state accordingly.
    func choose(card: Card, selectedCardIds: inout Set<Int>) {
        if selectedCardIds.count >= model.setSize {
            selectedCardIds.removeAll()
            resetMismatchedCards()
        }
        toggle(card: card, selectedCardIds: &selectedCardIds)
    }

    /// Flips the selection of the given `card` by updating `selectedCardIds`.
    private func toggle(card: Card, selectedCardIds: inout Set<Int>) {
        guard card.state != .matched else { return }

        if selectedCardIds.contains(card.id) {
            selectedCardIds.remove(card.id)
        } else {
            selectedCardIds.insert(card.id)
        }
    }

    /// Checks if the given `selectedCardIds` form a matching set.
    func tryToMatchCards(withIds selectedCardIds: Set<Int>) {
        model.tryToMatchCards(withIds: selectedCardIds)
    }

    /// Removes matched cards from the table.
    func discardMatchedCards(withReplacement: Bool = false) -> Int {
        let matchedCount = model.changeCardState(from: .matched, to: .done)
        if withReplacement {
            model.dealMoreCards(numberOfCards: matchedCount)
        }
        return matchedCount
    }

    /// Resets any mismatched cards.
    func resetMismatchedCards() {
        let _ = model.changeCardState(from: .mismatched, to: .unmatched)
    }

    /// Adds more cards to the table.
    func dealMoreCards() {
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
