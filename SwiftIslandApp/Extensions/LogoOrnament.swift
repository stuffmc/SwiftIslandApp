import SwiftUI

struct LogoOrnamentModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
#if os(visionOS)
            .ornament(attachmentAnchor: .scene(.top)) {
                SwiftIslandLogo(isAnimating: false, depth: 10)
                    .frame(height: 80)
            }
#endif
    }
}

extension View {
    func logoOrnament() -> some View {
        self.modifier(LogoOrnamentModifier())
    }
}

#Preview {
    Text("Main View")
        .font(.largeTitle)
        .paddedGlassBackgroundEffect()
        .logoOrnament()
}
