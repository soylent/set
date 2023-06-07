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

    /// The view body.
    var body: some View {
        let cardTile = RoundedRectangle(cornerRadius: DrawingConstants.cardCornerRadius)
        ZStack {
            cardTile.foregroundColor(.white)
            cardTile.strokeBorder(lineWidth: cardLineWidth).foregroundColor(cardColor)

            CardSymbolView(cardAttributes: card.attributes)
        }
    }

    /// The width of the card outline.
    private var cardLineWidth: CGFloat {
        card.isSelected ? DrawingConstants.selectedCardLineWidth : DrawingConstants.unselectedCardLineWidth
    }

    /// The color of the card outline.
    private var cardColor: Color {
        switch card.state {
        case .matched:
            return .green
        case .mismatched:
            return .red
        default:
            return .blue
        }
    }

    private struct DrawingConstants {
        static let cardCornerRadius: CGFloat = 12
        static let selectedCardLineWidth: CGFloat = 3
        static let unselectedCardLineWidth: CGFloat = 1
    }
}
