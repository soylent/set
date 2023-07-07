//
//  Diamond.swift
//  SetGame
//
//  Created by soylent on 6/4/23.
//

import SwiftUI

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        let left = CGPoint(x: rect.minX, y: rect.midY)
        let right = CGPoint(x: rect.maxX, y: rect.midY)
        let top = CGPoint(x: rect.midX, y: rect.minY)
        let bottom = CGPoint(x: rect.midX, y: rect.maxY)

        var path = Path()
        path.move(to: left)
        path.addLine(to: top)
        path.addLine(to: right)
        path.addLine(to: bottom)
        path.closeSubpath()

        return path
    }
}
