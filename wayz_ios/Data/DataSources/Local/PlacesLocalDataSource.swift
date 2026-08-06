//
//  PlacesLocalDataSource.swift
//  wayz_ios
//

import Foundation

/// Local cache for places data.
/// Currently uses in-memory storage. Swap out for CoreData/SwiftData as needed.
final class PlacesLocalDataSource {
    private var cachedPlaces: [Places]?
    private var cachedDetails: [String: Places] = [:]
    private var cachedComments: [String: [Comment]] = [:]

    func getPlaces(search: String?) -> [Places]? {
        guard let cachedPlaces, search == nil else { return nil }
        return cachedPlaces
    }

    func savePlaces(_ places: [Places], search: String?) {
        guard search == nil else { return }
        cachedPlaces = places
    }

    func getPlaceDetail(id: String) -> Places? {
        cachedDetails[id]
    }

    func savePlaceDetail(_ place: Places) {
        cachedDetails[place.id] = place
    }

    func getComments(placeId: String) -> [Comment]? {
        cachedComments[placeId]
    }

    func saveComments(_ comments: [Comment], placeId: String) {
        cachedComments[placeId] = comments
    }

    func clear() {
        cachedPlaces = nil
        cachedDetails.removeAll()
        cachedComments.removeAll()
    }
}
