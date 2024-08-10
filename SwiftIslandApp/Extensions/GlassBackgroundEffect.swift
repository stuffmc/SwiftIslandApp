//
// Created by StuFF mc for the use in the Swift Island app
// Copyright © 2024 AppTrix AB. All rights reserved.
//
import SwiftUI

struct PaddedGlassBackgroundEffect: ViewModifier {
    func body(content: Content) -> some View {
        content
#if os(visionOS)
            .padding()
            .glassBackgroundEffect()
#endif
    }
}

extension View {
  func paddedGlassBackgroundEffect() -> some View {
    self.modifier(PaddedGlassBackgroundEffect())
  }
}
