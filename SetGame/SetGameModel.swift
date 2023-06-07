//
//  SetGameModel.swift
//  SetGame
//
//  Created by user on 6/3/23.
//

import Foundation

protocol SetMatchable {
    static var setSize: Int { get }

    associatedtype T: Hashable
    var rawAttributes: [T] { get }
}

/// Model that encapsulates the game logic.
struct SetGameModel<CardAttributes: SetMatchable> {
    var cards: [Card]
    let setSize: Int

    private var selectedCards: [Card] { cards.filter { $0.isSelected } }

    init(numberOfCards: Int, setSize: Int, initialDealingSize: Int, cardAttributes: [CardAttributes]) {
        self.setSize = setSize
        self.cards = zip(cardAttributes.indices, cardAttributes).map { index, attrs in
            Card(id: index, attributes: attrs)
        }
        .shuffled()

        dealMoreCards(count: initialDealingSize)
    }

    mutating func choose(_ card: Card) {
        guard let cardIndex = cardIndexBy(id: card.id) else { return }

        dealMoreCards(count: cleanUpMatchedCards())
        cleanUpMismatchedCards()

        if cards[cardIndex].state != .done {
            cards[cardIndex].isSelected.toggle()
        }

        if selectedCards.count == setSize {
            let matched = Card.isMatchingSet(selectedCards)
            for card in selectedCards {
                if let cardIndex = cardIndexBy(id: card.id) {
                    cards[cardIndex].state = matched ? .matched : .mismatched
                }
            }
        }
    }

    mutating func cleanUpMatchedCards() -> Int {
        let matchedCardIndices = cardIndicesBy(state: .matched)
        for index in matchedCardIndices {
            cards[index].state = .done
            cards[index].isSelected = false
        }
        return matchedCardIndices.count
    }

    mutating private func cleanUpMismatchedCards() {
        for index in cardIndicesBy(state: .mismatched) {
            cards[index].state = .unmatched
            cards[index].isSelected = false
        }
    }

    mutating func dealMoreCards(count: Int) {
        let deckCardIndices = cardIndicesBy(state: .deck)
        let numberOfCards = min(count, deckCardIndices.count)
        deckCardIndices[0..<numberOfCards].forEach {
            cards[$0].state = .unmatched
        }
    }

    func cardsBy(states: Card.State...) -> [Card] {
        cards.filter { states.contains($0.state) }
    }

    private func cardIndicesBy(state: Card.State) -> [Int] {
        cardsBy(states: state).map { cardIndexBy(id: $0.id)! }
    }

    private func cardIndexBy(id: Int) -> Int? {
        cards.firstIndex { $0.id == id }
    }

    struct Card: Identifiable {
        let id: Int
        let attributes: CardAttributes
        var isSelected = false
        var state: State = .deck

        static func isMatchingSet(_ cards: [Card]) -> Bool {
            let attrCount = cards[0].attributes.rawAttributes.count
            for index in 0..<attrCount {
                let distinctAttrs = Set(cards.map { $0.attributes.rawAttributes[index] })
                if distinctAttrs.count > 1 && distinctAttrs.count < CardAttributes.setSize {
                    return false
                }
            }
            return true
        }

        enum State {
            case deck, unmatched, matched, mismatched, done
        }
    }
}
