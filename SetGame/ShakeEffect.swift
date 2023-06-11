//
//  Shake.swift
//  SetGame
//
//  Created by user on 6/11/23.
//

import SwiftUI

/// Shaking effect.
struct ShakeEffect: GeometryEffect {
    /// Alias for the angle property.
    var animatableData: Double {
        get { angle }
        set { angle = newValue }
    }
    /// Controls the horizontal offset of the view.
    private var angle: Double
    /// Max angle value controls the number of shakes.
    private static let maxAngle = 720.0
    /// Shaking amplitude.
    private static let amplitude = 10.0

    /// Creates a new instance of the effect.
    init(shake: Bool) {
        angle = shake ? Self.maxAngle : 0.0
    }

    /// Returns a transformation matrix.
    func effectValue(size: CGSize) -> ProjectionTransform {
        let xOffset = Self.amplitude * sin(Angle(degrees: angle).radians)

        return ProjectionTransform(CGAffineTransform(translationX: xOffset, y: 0))
    }
}

extension View {
    /// Adds a shaking effect to the view if the `shake` flag is true.
    func shaking(_ shake: Bool) -> some View {
        modifier(ShakeEffect(shake: shake))
    }
}
