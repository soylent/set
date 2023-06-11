//
//  CardView.swift
//  SetGame
//
//  Created by user on 6/5/23.
//

import SwiftUI

/// A view that represents a single Set card.
struct CardView: View {
    /// An instance of the card model.
    let card: SetGameViewModel.Card
    /// Whether or not the face is up.
    var isFaceUp = true
    /// An array of card ids that are currently selected.
    @Binding var selectedCardIds: Set<Int>
    /// Whether or not the card is currently selected.
    private var selected: Bool { selectedCardIds.contains(card.id) }

    /// The view body.
    var body: some View {
        let cardTile = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
        if isFaceUp {
            ZStack {
                cardTile.fill(.white)
                cardTile.strokeBorder(lineWidth: cardLineWidth).foregroundColor(DrawingConstants.borderColor)

                GeometryReader { geometry in
                    VStack {
                        Spacer(minLength: 0)
                        CardSymbolView(cardAttributes: card.attributes)
                            .padding(.horizontal, symbolPadding(for: geometry.size.width))
                        Spacer(minLength: 0)
                    }
                }
            }
            .shaking(card.state == .mismatched)
        } else {
            cardTile.fill(DrawingConstants.backColor)
        }
    }

    /// Horizontal symbol padding for the given `cardWidth`.
    private func symbolPadding(for cardWidth: CGFloat) -> CGFloat {
        cardWidth * DrawingConstants.relativeHorizontalSymbolPadding
    }

    /// The width of the card outline.
    private var cardLineWidth: CGFloat {
        selected ? DrawingConstants.selectedCardLineWidth : DrawingConstants.unselectedCardLineWidth
    }

    /// The color of the card outline.
    private var cardColor: Color {
        switch card.state {
        case .matched:
            return .green
        case .mismatched:
            return .red
        default:
            return .white
        }
    }

    private struct DrawingConstants {
        static let backColor: Color = .orange
        static let borderColor: Color = .blue
        static let cornerRadius: CGFloat = 12
        static let selectedCardLineWidth: CGFloat = 3
        static let unselectedCardLineWidth: CGFloat = 1
        static let relativeHorizontalSymbolPadding: CGFloat = 0.2
    }
}
