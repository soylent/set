//
//  CardSymbolView.swift
//  SetGame
//
//  Created by soylent on 6/6/23.
//

import SwiftUI

/// A view that represents symbol(s) on the card face.
struct CardSymbolView: View {
    /// An instance of the card attributes.
    let cardAttributes: VanillaCardAttributes

    /// The view body.
    var body: some View {
        VStack {
            let numberOfSymbols = cardAttributes.number.rawValue
            ForEach(0 ..< numberOfSymbols, id: \.self) { _ in
                symbol
                    .aspectRatio(DrawingConstants.aspectRatio, contentMode: .fit)
                    .foregroundColor(symbolColor)
            }
        }
    }

    /// A view that represents a single symbol shown on the card face.
    @ViewBuilder
    private var symbol: some View {
        switch cardAttributes.symbol {
        case .diamond:
            shaded(Diamond())
        case .oval:
            shaded(Capsule())
        case .squiggle:
            shaded(Rectangle())
        }
    }

    /// Applies shading to a card symbol based on the card attributes.
    @ViewBuilder
    private func shaded(_ symbol: some Shape) -> some View {
        switch cardAttributes.shading {
        case .solid:
            symbol.fill()
        case .open:
            symbol.stroke(lineWidth: DrawingConstants.openShadingLineWidth)
        case .striped:
            symbol.opacity(DrawingConstants.stripedShadingOpacity)
        }
    }

    /// The color of each symbol.
    private var symbolColor: Color {
        switch cardAttributes.color {
        case .red:
            return .red
        case .green:
            return .green
        case .purple:
            return .purple
        }
    }

    private enum DrawingConstants {
        static let aspectRatio: CGFloat = 9 / 4
        static let openShadingLineWidth: CGFloat = 4
        static let stripedShadingOpacity: CGFloat = 0.4
    }
}
