//
//  CardView.swift
//  SetGame
//
//  Created by user on 6/5/23.
//

import SwiftUI

struct CardView: View {
    let card: SetGameViewModel.Card

    var body: some View {
        let cardTile = RoundedRectangle(cornerRadius: DrawingConstants.cardCornerRadius)
        ZStack {
            cardTile.foregroundColor(.white)
            cardTile.strokeBorder(lineWidth: cardLineWidth).foregroundColor(cardColor)

            CardSymbolView(cardAttributes: card.attributes)
        }
    }

    private var cardLineWidth: CGFloat {
        card.isSelected ? DrawingConstants.selectedCardLineWidth : DrawingConstants.unselectedCardLineWidth
    }

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
