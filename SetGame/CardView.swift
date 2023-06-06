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
        let rect = RoundedRectangle(cornerRadius: DrawingConstants.cardCornerRadius)
        ZStack {
            rect.foregroundColor(.white)
            rect.strokeBorder(lineWidth: cardLineWidth).foregroundColor(cardColor)
            VStack {
                let numberOfSymbols = card.attributes.number.rawValue
                ForEach(0..<numberOfSymbols, id: \.self) { _index in
                    symbol
                        .aspectRatio(DrawingConstants.symbolAspectRatio, contentMode: .fit)
                        .foregroundColor(symbolColor)
                        .padding(.horizontal, DrawingConstants.symbolHorizontalPadding)
                }
            }
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

    private var symbolColor: Color {
        switch card.attributes.color {
        case .red:
            return .red
        case .green:
            return .green
        case .purple:
            return .purple
        }
    }

    @ViewBuilder
    private var symbol: some View {
        switch card.attributes.symbol {
        case .diamond:
            shaded(Diamond())
        case .oval:
            shaded(Capsule())
        case .squiggle:
            shaded(Rectangle())
        }
    }

    @ViewBuilder
    private func shaded<Symbol: Shape>(_ symbol: Symbol) -> some View {
        switch card.attributes.shading {
        case .solid:
            symbol.fill()
        case .open:
            symbol.stroke(lineWidth: DrawingConstants.openShadingLineWidth)
        case .striped:
            symbol.opacity(DrawingConstants.stripedShadingOpacity)
        }
    }

    private struct DrawingConstants {
        static let stripedShadingOpacity: CGFloat = 0.4
        static let openShadingLineWidth: CGFloat = 4
        static let cardCornerRadius: CGFloat = 12
        static let selectedCardLineWidth: CGFloat = 3
        static let unselectedCardLineWidth: CGFloat = 1
        static let symbolAspectRatio: CGFloat = 2/1
        static let symbolHorizontalPadding: CGFloat = 13
    }
}
