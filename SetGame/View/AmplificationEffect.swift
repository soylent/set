//
//  AmplifyingEffect.swift
//  SetGame
//
//  Created by user on 6/11/23.
//

import SwiftUI

/// Amplification effect.
struct AmplificationEffect: Animatable, ViewModifier {
    /// Alias for the angle property.
    var animatableData: Double {
        get { angle }
        set { angle = newValue }
    }

    /// Controls the scale of the view.
    private var angle: Double
    /// Max angle value controls the number of cycles.
    private static let maxAngle = 720.0
    /// Scaling amplitude.
    private static let amplitude = 0.20

    /// Create an instance of the effect.
    init(amplify: Bool) {
        angle = amplify ? Self.maxAngle : 0.0
    }

    /// Returns the modified view.
    func body(content: Content) -> some View {
        content.scaleEffect(cos(Angle(degrees: angle).radians) * Self.amplitude + 1.0)
    }
}

extension View {
    /// Adds an amplification effect to the view if the `amplify` flag is true.
    func amplify(_ amplify: Bool) -> some View {
        modifier(AmplificationEffect(amplify: amplify))
    }
}
