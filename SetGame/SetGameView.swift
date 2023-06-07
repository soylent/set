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

    /// The view body.
    var body: some View {
        VStack {
            cardGrid
            bottomMenu
        }
    }

    /// All cards that are currently on the table.
    private var cardGrid: some View {
        AspectVGrid(
            items: game.visibleCards, aspectRatio: DrawingConstants.cardAspectRatio, minItemWidth: DrawingConstants.minCardWidth
        ) { card in
            CardView(card: card).padding(DrawingConstants.cardPadding).onTapGesture {
                game.choose(card)
            }
        }
        .padding()

    }

    /// The menu at the bottom of the screen.
    private var bottomMenu: some View {
        HStack {
            Button {
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
        static let cardAspectRatio: CGFloat = 5/8
        static let cardPadding: CGFloat = 2
        static let minCardWidth: CGFloat = 60
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView(game: SetGameViewModel())
    }
}
