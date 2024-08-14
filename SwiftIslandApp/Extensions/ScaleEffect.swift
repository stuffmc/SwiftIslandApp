//
// Created by StuFF mc for the use in the Swift Island app
// Copyright © 2024 AppTrix AB. All rights reserved.
//
import SwiftUI

struct ScaleHoverModifier: ViewModifier {
    var action: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
#if os(visionOS)
            .hoverEffect { effect, isActive, _ in
                effect.scaleEffect(isActive ? 1.2 : 1)
            }
#endif
            .onTapGesture {
                if let action {
                    action()
                }
            }
    }
}

extension View {
    func scaleHover(action: (() -> Void)? = nil) -> some View {
      self.modifier(ScaleHoverModifier(action: action))
  }
}
