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

    /// The view body.
    var body: some View {
        VStack {
            cardGrid
            HStack {
                pile(of: game.remainingCards, isFaceUp: false)
                Spacer()
                pile(of: game.doneCards, isFaceUp: true)
            }
            .frame(height: 110)
            bottomMenu
        }
        .padding()
    }

    private func pile(of cards: [SetGameViewModel.Card], isFaceUp: Bool) -> some View {
        ZStack {
            ForEach(cards) { card in
                CardView(card: card, isFaceUp: isFaceUp, selectedCardIds: $selectedCardIds)
            }
        }
        .aspectRatio(DrawingConstants.cardAspectRatio, contentMode: .fit)
    }

    /// All cards that are currently on the table.
    private var cardGrid: some View {
        AspectVGrid(
            items: game.visibleCards, aspectRatio: DrawingConstants.cardAspectRatio, minItemWidth: DrawingConstants.minCardWidth
        ) { card in
            CardView(card: card, selectedCardIds: $selectedCardIds)
                .padding(DrawingConstants.cardPadding)
                .onTapGesture {
                    game.choose(card: card, selectedCardIds: &selectedCardIds)
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

            Button {
                game.dealMoreCards()
            } label: {
                Image(systemName: "plus.circle.fill")
            }
            .disabled(game.deckIsEmpty)
        }
        .font(.largeTitle)
    }

    private struct DrawingConstants {
        static let cardAspectRatio: CGFloat = 3/4
        static let cardPadding: CGFloat = 2
        static let minCardWidth: CGFloat = 60
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView(game: SetGameViewModel())
    }
}
