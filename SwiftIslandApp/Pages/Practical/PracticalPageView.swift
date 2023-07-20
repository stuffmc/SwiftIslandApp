//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import CoreLocation
import Defaults

struct PracticalPageView: View {

    private let iconMaxWidth: CGFloat = 32

    @Default(.userIsActivated) private var userIsActivated

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient.defaultBackground

                List {
                    SectionBeforeYouLeave(iconMaxWidth: iconMaxWidth)

                    SectionGettingHere(iconMaxWidth: iconMaxWidth)

                    if userIsActivated {
                        SectionAtTheConference(iconMaxWidth: iconMaxWidth)
                    } else {
                        SectionAtTheConferenceNotActivated(iconMaxWidth: iconMaxWidth)
                    }
                }
                .scrollContentBackground(.hidden)
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: 44)
                }
            }
            .navigationTitle("Practical")
        }
    }
}

struct PracticalPageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PracticalPageView()
                .previewDisplayName("Light mode")
            PracticalPageView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark mode")
        }
    }
}

struct SectionBeforeYouLeave: View {
    let iconMaxWidth: CGFloat

    var body: some View {
        Section(header: Text("Before you leave")) {
            HStack {
                Text("Make sure you are all set for a few days of awesome workshops.")
                    .font(.subheadline)
            }
            NavigationLink(destination: {
                Text("Packlist")
            }, label: {
                HStack {
                    Image(systemName: "suitcase.rolling")
                        .foregroundColor(.questionMarkColor)
                        .frame(maxWidth: iconMaxWidth)
                    Text("Packlist")
                        .dynamicTypeSize(.small ... .medium)
                }
            })
        }
    }
}

struct SectionGettingHere: View {
    let iconMaxWidth: CGFloat

    @State private var isShowingMapView = false

    var body: some View {
        Section(header: Text("Getting here")) {
            Button {
                isShowingMapView.toggle()
            } label: {
                VStack {
                    let location = Location(coordinate: CLLocationCoordinate2D(latitude: 53.11478763673313, longitude: 4.8972633598615065))
                    GettingThereMapView(locations: [location])
                        .padding(0)
                        .allowsHitTesting(false)
                }
                .frame(minHeight: 110)
            }
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            NavigationLink(destination: {
                Text("Hassle Free Ticket")
            }, label: {
                HStack {
                    Image(systemName: "ticket")
                        .foregroundColor(.questionMarkColor)
                        .frame(maxWidth: iconMaxWidth)
                    Text("Hassle Free Ticket")
                        .dynamicTypeSize(.small ... .medium)
                }
            })
            NavigationLink(destination: {
                Text("Schiphol")
            }, label: {
                HStack {
                    Image(systemName: "airplane.arrival")
                        .foregroundColor(.questionMarkColor)
                        .frame(maxWidth: iconMaxWidth)
                    Text("At Schiphol")
                        .dynamicTypeSize(.small ... .medium)
                }
            })

            NavigationLink(destination: {
                Text("Directions")
            }, label: {
                HStack {
                    Image(systemName: "bicycle")
                        .foregroundColor(.questionMarkColor)
                        .frame(maxWidth: iconMaxWidth)
                    Text("Directions")
                        .dynamicTypeSize(.small ... .medium)
                }
            })
            NavigationLink(destination: {
                Text("On location")
            }, label: {
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.questionMarkColor)
                        .frame(maxWidth: iconMaxWidth)
                    Text("On Location")
                        .dynamicTypeSize(.small ... .medium)
                }
            })
        }
    }
}

struct SectionAtTheConference: View {
    let iconMaxWidth: CGFloat

    var body: some View {
        Section(header: Text("At the conference")) {
            HStack {
                Text("You made it! We are very happy too see you made it to the conference!")
                    .font(.subheadline)
            }
            NavigationLink(destination: {
                Text("Schedule")
            }, label: {
                HStack {
                    Image(systemName: "calendar.day.timeline.leading")
                        .foregroundColor(.questionMarkColor)
                        .frame(maxWidth: iconMaxWidth)
                    Text("Checkout the schedule")
                        .dynamicTypeSize(.small ... .medium)
                }
            })
            NavigationLink(destination: {
                Text("Map")
            }, label: {
                HStack {
                    Image(systemName: "map")
                        .foregroundColor(.questionMarkColor)
                        .frame(maxWidth: iconMaxWidth)
                    Text("Map")
                        .dynamicTypeSize(.small ... .medium)
                }
            })
            NavigationLink(destination: {
                Text("Slack")
            }, label: {
                HStack {
                    Image(systemName: "message")
                        .foregroundColor(.questionMarkColor)
                        .frame(maxWidth: iconMaxWidth)
                    Text("Join our Slack")
                        .dynamicTypeSize(.small ... .medium)
                }
            })
        }
    }
}
