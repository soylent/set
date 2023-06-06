//
//  SetGameModel.swift
//  SetGame
//
//  Created by user on 6/3/23.
//

import Foundation

protocol SetMatchable {
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
        self.cards = zip(cardAttributes.indices, cardAttributes).map { index, attrs in Card(id: index, attributes: attrs) }.shuffled()

        dealMoreCards(count: initialDealingSize)
    }

    mutating func choose(_ card: Card) {
        cleanUpTheTable()

        guard card.state == .unmatched, let cardIndex = cardIndexBy(id: card.id) else { return }

        cards[cardIndex].isSelected.toggle()

        if selectedCards.count == setSize {
            let matched = Card.isMatchingSet(selectedCards)
            for card in selectedCards {
                if let cardIndex = cardIndexBy(id: card.id) {
                    cards[cardIndex].state = matched ? .matched : .mismatched
                }
            }
        }
    }

    mutating private func cleanUpTheTable() {
        cardIndicesBy(state: .mismatched).forEach {
            cards[$0].state = .unmatched
            cards[$0].isSelected = false
        }
        cardIndicesBy(state: .matched).forEach {
            cards[$0].state = .done
            cards[$0].isSelected = false
            dealMoreCards()
        }
    }

    mutating func dealMoreCards(count: Int = 1) {
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
                if distinctAttrs.count > 1 && distinctAttrs.count < attrCount {
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
