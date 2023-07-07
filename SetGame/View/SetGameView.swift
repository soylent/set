//
//  SetGameView.swift
//  SetGame
//
//  Created by soylent on 6/3/23.
//

import SwiftUI

/// The main game view.
struct SetGameView: View {
    /// A reference to the view model instance.
    @ObservedObject var game: SetGameViewModel
    /// Namespace for card ids.
    @Namespace private var cardNamespace

    /// The view body.
    var body: some View {
        VStack {
            cardGrid
            cardPiles
            bottomMenu
        }
        .padding()
    }

    /// All cards that are currently on the table.
    private var cardGrid: some View {
        AspectVGrid(
            items: game.visibleCards,
            aspectRatio: DrawingConstants.cardAspectRatio,
            minItemWidth: DrawingConstants.minCardWidth
        ) { card in
            CardView(card: card, selected: game.isSelected(card))
                .zIndex(zIndex(for: card, in: game.cards))
                .padding(DrawingConstants.cardPadding)
                .matchedGeometryEffect(id: card.id, in: cardNamespace)
                .onTapGesture {
                    game.choose(card: card)
                    dealCards()
                    game.tryToMatchSelectedCards()
                }
        }
    }

    /// The deck and a pile of discarded cards.
    private var cardPiles: some View {
        HStack {
            pile(of: game.remainingCards, isFaceUp: false, indexIn: game.cards)
                .onTapGesture {
                    dealCards(replacingMatchedOnly: false)
                }
            Spacer()
            pile(of: game.doneCards, isFaceUp: true, indexIn: game.doneCards)
        }
        .frame(height: DrawingConstants.pileHeight)
    }

    /// The menu at the bottom of the screen.
    private var bottomMenu: some View {
        HStack {
            Button {
                game.deselectAllCards()
                game.startNewGame()
            } label: {
                Image(systemName: "arrow.clockwise.circle.fill")
            }
        }
        .font(.largeTitle)
    }

    /// Returns a view representing a pile of given `cards`.
    private func pile(of cards: [SetGameViewModel.Card], isFaceUp: Bool, indexIn allCards: [SetGameViewModel.Card]) -> some View {
        ZStack {
            ForEach(cards) { card in
                let offset = CGFloat(card.index(in: allCards) / DrawingConstants.miniStackSize * DrawingConstants.miniStackOffset)
                CardView(card: card, isFaceUp: isFaceUp)
                    .offset(x: 0, y: offset)
                    .zIndex(zIndex(for: card, in: allCards))
                    .matchedGeometryEffect(id: card.id, in: cardNamespace)
            }
        }
        .aspectRatio(DrawingConstants.cardAspectRatio, contentMode: .fit)
    }

    /// Returns a zIndex value for the given `card` contained within `cards`.
    private func zIndex(for card: SetGameViewModel.Card, in cards: [SetGameViewModel.Card]) -> Double {
        -Double(card.index(in: cards))
    }

    /// Discards any matched cards and draws more cards from the deck.
    private func dealCards(replacingMatchedOnly: Bool = true) {
        let matchedCount = withAnimation {
            game.discardMatchedCards()
        }
        if matchedCount > 0 || !replacingMatchedOnly {
            let delay = matchedCount > 0 ? DrawingConstants.dealingDelay : 0.0
            withAnimation(.default.delay(delay)) {
                game.dealCards()
            }
        }
    }

    private enum DrawingConstants {
        static let cardAspectRatio: CGFloat = 3 / 4
        static let cardPadding: CGFloat = 2
        static let dealingDelay: CGFloat = 0.06
        static let miniStackSize = 12
        static let miniStackOffset = 2
        static let minCardWidth: CGFloat = 60
        static let pileHeight: CGFloat = 110
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView(game: SetGameViewModel())
    }
}
