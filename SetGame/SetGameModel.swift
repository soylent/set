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
    /// The number of cards that can form a matching set.
    let setSize: Int

    /// Creates a new game instance with the given settings and `cardAttributes`.
    init(cardAttributes: [CardAttributes], setSize: Int, initialDealingSize: Int) {
        self.setSize = setSize
        self.cards = zip(cardAttributes.indices, cardAttributes).map { index, attrs in
            Card(id: index, attributes: attrs)
        }
        .shuffled()

        dealMoreCards(numberOfCards: initialDealingSize)
    }

    /// Tries to match the cards with the given `cardIds` and updates their state accordingly.
    mutating func tryToMatchCards(withIds cardIds: Set<Int>) {
        let cardIndices = cardIds.compactMap { cardIndexBy(id: $0) }

        guard cardIndices.count == setSize else { return }

        let selectedCards = cardIndices.map { cards[$0] }
        let matched = Card.isMatchingSet(selectedCards, setSize: setSize)
        for cardIndex in cardIndices {
            cards[cardIndex].state = matched ? .matched : .mismatched
        }
    }

    /// Removes any matched or mismatched cards with replacement if `replacingMatchedCards` is true.
    mutating func cleanUpTheTable(replacingMatchedCards: Bool = true) {
        let matchedCardIndices = cardIndicesBy(state: .matched)
        for index in matchedCardIndices {
            cards[index].state = .done
        }
        for index in cardIndicesBy(state: .mismatched) {
            cards[index].state = .unmatched
        }
        if replacingMatchedCards {
            dealMoreCards(numberOfCards: matchedCardIndices.count)
        }
    }

    /// Add the given `numberOfCards` to the table.
    mutating func dealMoreCards(numberOfCards: Int) {
        let deckCardIndices = cardIndicesBy(state: .deck)
        let numberOfCards = min(numberOfCards, deckCardIndices.count)
        deckCardIndices[0..<numberOfCards].forEach {
            cards[$0].state = .unmatched
        }
    }

    /// Returns cards that are in one of the given `states`.
    func cardsBy(states: Card.State...) -> [Card] {
        cards.filter { states.contains($0.state) }
    }

    /// Returns indices of cards that are in the given `state`.
    private func cardIndicesBy(state: Card.State) -> [Int] {
        cardsBy(states: state).map { cardIndexBy(id: $0.id)! }
    }

    /// Returns the card index given its `id`.
    private func cardIndexBy(id: Int) -> Int? {
        cards.firstIndex { $0.id == id }
    }

    /// A single Set card.
    struct Card: Identifiable {
        /// The identifier of the card.
        let id: Int
        /// Attributes that define the card.
        let attributes: CardAttributes
        /// The current state of the card.
        var state: State = .deck

        /// Returns true if the given `cards` form a matching set of the given `setSize`, and false otherwise.
        static func isMatchingSet(_ cards: [Card], setSize: Int) -> Bool {
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
