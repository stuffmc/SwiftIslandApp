//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import Foundation
import os.log
import SwiftUI
import Defaults
import SwiftIslandDataLogic

/// The state of the app, if the app is loading data, this state will be `initialising`.
enum AppState {
    case initialising
    case loaded
}

/// AppDataModel hold app data that is used by multiple views and is shared as an environment variable to the views.
/// This class is used on the main dispatch queue
final class AppDataModel: ObservableObject {
    @Published var appState = AppState.initialising
    @Published var mentors: [Mentor] = []
    @Published var pages: [Page] = []
    @Published var activities: [Activity] = []
    @Published var events: [Event] = []
    @Published var locations: [Location] = []
    @Published var tickets: [Ticket] = []
    @Published var puzzles: [Puzzle] = []

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!, // swiftlint:disable:this force_unwrapping
        category: String(describing: AppDataModel.self)
    )

    private let dataLogic: DataLogic

    init(dataLogic: DataLogic = SwiftIslandDataLogic()) {
        self.dataLogic = dataLogic
        if !isShowingPreview() {
            Task {
                await fetchData()
            }
        }
    }

    /// Checks the event list and pick the next event from it
    /// - Returns: The next event, if there is any
    func nextEvent() async -> Event? {
        if events.isEmpty {
            self.events = await fetchEvents()
        }

        return events
            .sorted { $0.startDate < $1.startDate }
            .first { $0.startDate > Date() }
    }

    /// Fetches all the stored locations
    /// - Returns: Array of `Location`
    @MainActor
    func fetchLocations() async {
        self.locations = await dataLogic.fetchLocations()
    }

    @MainActor
    func fetchPuzzles() async {
        self.puzzles = await dataLogic.fetchPuzzles()
    }

    /// Fetches items for packing list. If none are stored locally, it'll get the list from Firebase.
    /// - Returns: Array of `PackingItem`
    func fetchPackingListItems() async -> [PackingItem] {
        if Defaults[.packingItems].isEmpty {
            let firebaseItems = await dataLogic.fetchPackingListItemsFromFirebase()
            Defaults[.packingItems] = firebaseItems
            return firebaseItems
        }

        return Defaults[.packingItems]
    }


    func updateTickets() async -> [Ticket] {
        let storedTickets: [Ticket] = (try? KeychainManager.shared.get(key: .tickets) ?? []) ?? []
        var updatedTickets: [Ticket] = []
        // Todo make these request perform in parallel using an AsyncStream
        for ticket in storedTickets {
            // We never throw a way a ticket, if it can't be fetch, just use the stored version
            let updatedTicket = (try? await dataLogic.fetchTicket(slug: ticket.slug, from: Secrets.checkinListSlug)) ?? ticket
            updatedTickets.append(updatedTicket)
        }
        return updatedTickets
    }


    func updateTicket(slug: String, add: Bool = true) async throws -> Ticket? {
        let ticket = try await dataLogic.fetchTicket(slug: slug, from: Secrets.checkinListSlug)
        if let index = tickets.firstIndex(where: { $0.slug == ticket.slug }) {
            await MainActor.run {
                self.tickets[index] = ticket
            }
        } else {
            if add {
                await MainActor.run {
                    self.tickets.append(ticket)
                }
            } else {
                return nil
            }
        }
        try KeychainManager.shared.store(key: .tickets, data: tickets)
        return ticket
    }

    func removeTicket(ticket: Ticket) throws {
        guard let index = tickets.firstIndex(where: { $0.id == ticket.id }) else { return }
        Task {
            await MainActor.run {
                self.tickets.remove(at: index)
                return
            }
            try KeychainManager.shared.store(key: .tickets, data: tickets)
        }
    }

    func fetchAnswers(for tickets: [Ticket]) async throws -> [Int: [Answer]] {
        try await dataLogic.fetchAnswers(for: tickets, in: Secrets.checkinListSlug)
    }
}

private extension AppDataModel {
    @MainActor
    func fetchData() {
        Task {
            mentors = await fetchMentors().shuffled()
            pages = await fetchPages()
            activities = await fetchActivities()
            events = await fetchEvents()
            tickets = await updateTickets()
            appState = .loaded
        }
    }

    /// Fetches all the mentors from Firebase
    /// - Returns: Array of `Mentor`
    func fetchMentors() async -> [Mentor] {
        await dataLogic.fetchMentors()
    }

    /// Fetches all the pages from Firebase and stores
    /// - Returns: Array of `Page`
    func fetchPages() async -> [Page] {
        await dataLogic.fetchPages()
    }

    /// Fetches all the activities
    /// - Returns: Array of `Activity`
    func fetchActivities() async -> [Activity] {
        await dataLogic.fetchActivities()
    }

    func fetchEvents() async -> [Event] {
        await dataLogic.fetchEvents()
    }
}

private enum Secrets {
    private static func secrets() throws -> [String: String] {
        let fileName = "Secrets"
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else { return [:] }

        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        return try JSONSerialization.jsonObject(with: data) as? [String: String] ?? [:]
    }

    static var checkinListSlug: String {
        (try? secrets()["CHECKIN_LIST_SLUG"]) ?? ""
    }
}
