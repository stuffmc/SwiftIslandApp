//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import Defaults

struct ConferenceHeaderView: View {
    private let startDate = Date(timeIntervalSince1970: 1724749200)

    @Default(.userIsActivated)
    private var userIsActivated

    var body: some View {
        VStack(spacing: 13) {
            if !userIsActivated {
                // TODO: Ask for a 3D Logo for visionOS (also used for App Icon)
                Image("Logo")
                VStack(spacing: 0) {
                    Text("Swift")
                        .font(.custom("WorkSans-Bold", size: 64))
                    Text("Island")
                        .font(.custom("WorkSans-Regular", size: 60))
                        .offset(CGSize(width: 0, height: -20))
                }
#if !os(visionOS)
                // TODO: Is this really necessary? Can't we just use semantic colors?
                .foregroundColor(.logoText)
#endif
            }
            HStack {
                Spacer()
                VStack {
                    Image("CalendarIcon")
                    VStack {
                        Text("Aug 27-29")
                            .font(.custom("WorkSans-Bold", size: 18))
                        Text(startDate.relativeDateDisplay())
                            .font(.custom("WorkSans-Regular", size: 14))
                    }
                }
                Spacer()
                VStack {
                    Image("LocationIcon")
                    VStack {
                        Text("Texel")
                            .font(.custom("WorkSans-Bold", size: 18))
                        Text("the Netherlands")
                            .font(.custom("WorkSans-Regular", size: 14))
                    }
                }
                Spacer()
            }
            .padding(.top, userIsActivated ? 30 : 0)
        }
    }
}

#Preview("Light / Vision") {
    ConferenceHeaderView()
        .preferredColorScheme(.light)
        .paddedGlassBackgroundEffect() // no-op on non-visionOS Platforms
}

#Preview("Dark") {
    ConferenceHeaderView()
        .preferredColorScheme(.dark)
}
