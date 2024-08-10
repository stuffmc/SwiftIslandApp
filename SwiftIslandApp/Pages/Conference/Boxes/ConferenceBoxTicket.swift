//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct ConferenceBoxTicket: View {
    var body: some View {
        ZStack {
            Image("BoxTicketBackground")
            Text("Buy Tickets")
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .font(.custom("WorkSans-Bold", size: 32))
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.ticketText)
                }
                .foregroundColor(.white)
                .onTapGesture {
                    UIApplication.shared.open(URL(string: "https://ti.to/swiftisland/2024")!) // swiftlint:disable:this force_unwrapping
                }
            #if os(visionOS)
                .hoverEffect { effect, isActive, _ in
                    effect.scaleEffect(isActive ? 1.2 : 1)
                }
            #endif
        }
        .mask {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
        }
    }
}

#Preview {
    ConferenceBoxTicket()
}
