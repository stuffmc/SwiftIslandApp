import SwiftUI

struct LogoOrnamentModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .ornament(attachmentAnchor: .scene(.top)) {
                SwiftIslandLogo(isAnimating: false, depth: 10)
                    .frame(height: 80)
            }
    }
}

extension View {
    func logoOrnament() -> some View {
        self.modifier(LogoOrnamentModifier())
    }
}

#Preview {
    Text("Main View")
        .font(.extraLargeTitle)
        .paddedGlassBackgroundEffect()
        .logoOrnament()
}
