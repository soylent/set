//
//  SetGameView.swift
//  SetGame
//
//  Created by user on 6/3/23.
//

import SwiftUI

/// The main game view.
struct SetGameView: View {
    /// A reference to the view model instance.
    @ObservedObject var game: SetGameViewModel
    /// An array of card ids that are currently selected.
    @State private var selectedCardIds: Set<Int> = []
    /// Namespace for card ids.
    @Namespace private var cardNamespace

    /// The view body.
    var body: some View {
        VStack {
            cardGrid
            HStack {
                pile(of: game.remainingCards, isFaceUp: false)
                    .onTapGesture {
                        dealMoreCards(replacingDiscardedOnly: false)
                    }
                Spacer()
                pile(of: game.doneCards, isFaceUp: true)
            }
            .frame(height: DrawingConstants.pileHeight)
            bottomMenu
        }
        .padding()
    }

    /// Returns a view that represents a file of given `cards`.
    private func pile(of cards: [SetGameViewModel.Card], isFaceUp: Bool) -> some View {
        ZStack {
            ForEach(cards) { card in
                CardView(card: card, isFaceUp: isFaceUp, selectedCardIds: $selectedCardIds)
                    .matchedGeometryEffect(id: card.id, in: cardNamespace)
            }
        }
        .aspectRatio(DrawingConstants.cardAspectRatio, contentMode: .fit)
    }

    private func dealMoreCards(replacingDiscardedOnly: Bool = true) {
        withAnimation {
            let matchedCount = game.discardMatchedCards()
            if matchedCount > 0 || !replacingDiscardedOnly {
                let delay = matchedCount > 0 ? DrawingConstants.dealingDelay : 0.0
                withAnimation(.default.delay(delay)) {
                    game.dealMoreCards()
                }
            }
        }

    }

    /// All cards that are currently on the table.
    private var cardGrid: some View {
        AspectVGrid(
            items: game.visibleCards, aspectRatio: DrawingConstants.cardAspectRatio, minItemWidth: DrawingConstants.minCardWidth
        ) { card in
            CardView(card: card, selectedCardIds: $selectedCardIds)
                .padding(DrawingConstants.cardPadding)
                .matchedGeometryEffect(id: card.id, in: cardNamespace)
                .onTapGesture {
                    game.choose(card: card, selectedCardIds: &selectedCardIds)
                    dealMoreCards()
                    game.tryToMatchCards(withIds: selectedCardIds)
                }
        }
    }

    /// The menu at the bottom of the screen.
    private var bottomMenu: some View {
        HStack {
            Button {
                selectedCardIds.removeAll()
                game.startNewGame()
            } label: {
                Image(systemName: "arrow.clockwise.circle.fill")
            }
        }
        .font(.largeTitle)
    }

    private struct DrawingConstants {
        static let cardAspectRatio: CGFloat = 3/4
        static let cardPadding: CGFloat = 2
        static let minCardWidth: CGFloat = 60
        static let pileHeight: CGFloat = 110
        static let dealingDelay: CGFloat = 0.06
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView(game: SetGameViewModel())
    }
}
