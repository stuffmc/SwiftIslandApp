//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct ConferencePageView: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [.conferenceBackgroundFrom, .conferenceBackgroundTo], startPoint: UnitPoint(x: 0, y: 0.1), endPoint: UnitPoint(x: 1, y: 1))
                .ignoresSafeArea()
            ScrollView {
                ConferenceHeaderView()
                ConferenceBoxTicket()
                    .padding(.vertical, 6)
                ConferenceBoxMentors()
                    .padding(.vertical, 6)
            }
        }
    }
}

struct ConferencePageView_Previews: PreviewProvider {
    static var previews: some View {
        ConferencePageView()
    }
}
