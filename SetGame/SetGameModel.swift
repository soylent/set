//
//  SetGameModel.swift
//  SetGame
//
//  Created by user on 6/3/23.
//

import Foundation

/// The protocol that any type that implements card attributes (e.g. shape, color) must conform to.
protocol SetMatchable {
    associatedtype T: Hashable
    /// An array that represents the attributes of a single card.
    var rawAttributes: [T] { get }
}

/// Model that encapsulates the game logic.
struct SetGameModel<CardAttributes: SetMatchable> {
    /// All available cards.
    var cards: [Card]
    /// All matched cards that have been discarded.
    var doneCards: [Card] = []
    /// The number of cards that can form a matching set.
    let setSize: Int

    /// Creates a new game instance with the given settings and `cardAttributes`.
    init(cardAttributes: [CardAttributes], setSize: Int, initialDealingSize: Int) {
        self.setSize = setSize
        self.cards = zip(cardAttributes.indices, cardAttributes).map { index, attrs in
            Card(id: index, attributes: attrs)
        }
        .shuffled()

        dealCards(numberOfCards: initialDealingSize)
    }

    /// Tries to match the cards with the given `cardIds` and updates their state accordingly.
    mutating func tryToMatchCards<CardIds: Sequence>(withIds cardIds: CardIds) where CardIds.Element == Int {
        let cardIndices = cardIds.compactMap { cardIndexBy(id: $0) }

        guard cardIndices.count == setSize else { return }

        let selectedCards = cardIndices.map { cards[$0] }
        let matched = Card.isMatchingSet(selectedCards, setSize: setSize)
        for cardIndex in cardIndices {
            cards[cardIndex].state = matched ? .matched : .mismatched
        }
    }

    /// Changes the state of cards in the `sourceState` to the `destinationState` and returns the number of affected cards.
    mutating func changeCardState(from sourceState: Card.State, to destinationState: Card.State, limit: Int? = nil) -> Int {
        let cardIndices = cardIndicesBy(state: sourceState)
        let limit = min(limit ?? cardIndices.count, cardIndices.count)
        for index in cardIndices[..<limit] {
            cards[index].state = destinationState
            if destinationState == .done {
                doneCards.append(cards[index])
            }
        }
        return cardIndices.count
    }

    /// Add the given `numberOfCards` to the table.
    mutating func dealCards(numberOfCards: Int) {
        let _ = changeCardState(from: .deck, to: .unmatched, limit: numberOfCards)
    }

    /// Returns cards that are in one of the given `states`.
    func cardsBy(states: Card.State...) -> [Card] {
        cards.filter { states.contains($0.state) }
    }

    /// Returns the card index given its `id`.
    func cardIndexBy(id: Int) -> Int? {
        cards.firstIndex { $0.id == id }
    }

    /// Returns indices of cards that are in the given `state`.
    private func cardIndicesBy(state: Card.State) -> [Int] {
        cardsBy(states: state).map { cardIndexBy(id: $0.id)! }
    }

    /// A single Set card.
    struct Card: Identifiable {
        /// The identifier of the card.
        let id: Int
        /// Attributes that define the card.
        let attributes: CardAttributes
        /// The current state of the card.
        var state: State = .deck
        /// Whether or not the card is currently matched.
        var isMatched: Bool { state == .matched }
        /// Whether or not the card is currently mismatched.
        var isMismatched: Bool { state == .mismatched }

        /// Returns the index of the card with the given collection of `cards`.
        func index(in cards: [Self], fallbackIndex: Int = 0) -> Int {
            cards.firstIndex { id == $0.id } ?? fallbackIndex
        }

        /// Returns true if the given `cards` form a matching set of the given `setSize`, and false otherwise.
        static func isMatchingSet(_ cards: [Self], setSize: Int) -> Bool {
            let attrCount = cards[0].attributes.rawAttributes.count
            for index in 0..<attrCount {
                let distinctAttrs = Set(cards.map { $0.attributes.rawAttributes[index] })
                if distinctAttrs.count > 1 && distinctAttrs.count < setSize {
                    return false
                }
            }
            return true
        }

        /// Card states.
        enum State {
            case deck, unmatched, mismatched, matched, done
        }
    }
}
