//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import FirebaseFirestore

struct ConferencePageView: View {
    @State private var mentors: [Mentor] = []

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.conferenceBackgroundFrom, .conferenceBackgroundTo], startPoint: UnitPoint(x: 0, y: 0.1), endPoint: UnitPoint(x: 1, y: 1))
                    .ignoresSafeArea()

                GeometryReader { geo in
                    ScrollView(.vertical) {
                        ConferenceHeaderView()
                        ConferenceBoxTicket()
                            .padding(.vertical, 6)

                        VStack(alignment: .leading) {
                            Text("Mentors this year".uppercased())
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 40)
                                .padding(.top, 6)
                                .padding(.bottom, 0)
                            ConferenceBoxMentors(mentors: $mentors)
                                .frame(height: geo.size.width * 0.50)
                                .padding(.vertical, 0)
                        }

                        ConferenceBoxFAQ()
                            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                            .scrollContentBackground(.hidden)
                    }
                }
            }
            .navigationDestination(for: [FAQItem].self) { _ in
                FAQListView()
            }
            .navigationDestination(for: FAQItem.self) { item in
                FAQListView(preselectedItem: item)
            }
            .navigationDestination(for: Mentor.self) { mentor in
                ConferenceMentorsView(mentors: mentors, selectedMentor: mentor)
            }
            .onAppear {
                fetchMentors()
            }
        }
    }

    private func fetchMentors() {
        Task {
            let request = AllMentorsRequest()
            do {
                let mentors = try await Firestore.get(request: request)
                self.mentors = mentors
            } catch {
                debugPrint("Could not fetch mentors. Error: \(error.localizedDescription)")
            }
        }
    }
}

struct ConferencePageView_Previews: PreviewProvider {
    static var previews: some View {
        ConferencePageView()
    }
}
