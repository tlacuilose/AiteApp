//
//  BounceEffect.swift
//  Aite
//
//  Created by Jose Tlacuilo on 26/03/25.
//
import SwiftUI

struct BounceEffect: GeometryEffect {
    var travelDistance: CGFloat = 10
    var numberOfShakes: CGFloat = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = travelDistance * sin(animatableData * .pi * numberOfShakes)
        return ProjectionTransform(CGAffineTransform(translationX: 0, y: translation))
    }
}
