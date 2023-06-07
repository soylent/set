//
//  CardSymbolView.swift
//  SetGame
//
//  Created by user on 6/6/23.
//

import SwiftUI

struct CardSymbolView: View {
    let cardAttributes: VanillaCardAttributes

    var body: some View {
        VStack {
            ForEach(0..<cardAttributes.number.rawValue, id: \.self) { _ in
                symbol
                    .aspectRatio(DrawingConstants.aspectRatio, contentMode: .fit)
                    .foregroundColor(symbolColor)
                    .padding(.horizontal, DrawingConstants.horizontalPadding)
            }
        }
    }

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

    @ViewBuilder
    private func shaded<Symbol: Shape>(_ symbol: Symbol) -> some View {
        switch cardAttributes.shading {
        case .solid:
            symbol.fill()
        case .open:
            symbol.stroke(lineWidth: DrawingConstants.openShadingLineWidth)
        case .striped:
            symbol.opacity(DrawingConstants.stripedShadingOpacity)
        }
    }

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

    private struct DrawingConstants {
        static let aspectRatio: CGFloat = 15/8
        static let horizontalPadding: CGFloat = 13
        static let openShadingLineWidth: CGFloat = 4
        static let stripedShadingOpacity: CGFloat = 0.4
    }
}
