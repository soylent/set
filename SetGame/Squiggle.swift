//
//  Squiggle.swift
//  SetGame
//
//  Created by user on 6/6/23.
//

import SwiftUI

struct Squiggle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.width * 2/4, y: rect.midY-50))
        path.addCurve(
            to: CGPoint(x: rect.width * 1/4, y: rect.midY+50),
            control1: CGPoint(x: rect.minX, y: rect.midY-100),
            control2: CGPoint(x: rect.minX, y: rect.midY )
        )
        return path
    }
}

struct Squiggle_Previews: PreviewProvider {
    static var previews: some View {
        Squiggle().padding()
    }
}
