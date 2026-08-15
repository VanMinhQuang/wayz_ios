//
//  MapViewModel.swift
//  wayz_ios
//
//  Created by Macbook on 5/7/26.
//

import CoreLocation
import Foundation
import Observation

@Observable
final class MapViewModel {
    var places: [Places] = []
    var searchText: String = ""
    var isLoading = false
    var errorMessage: String?

    private let placesRepository: PlacesRepositoryProtocol

    init(placesRepository: PlacesRepositoryProtocol) {
        self.placesRepository = placesRepository
    }

    func loadPlaces() async {
        isLoading = true
        errorMessage = nil
        do {
            places = try await placesRepository.fetchPlaces(search: nil)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    /// Reloads places around a coordinate, e.g. after recentering the map on
    /// the user's current location.
    func reloadNearbyPlaces(around coordinate: CLLocationCoordinate2D) async {
        isLoading = true
        errorMessage = nil
        do {
            places = try await placesRepository.searchNearby(
                lat: coordinate.latitude,
                lng: coordinate.longitude,
                radiusM: nil,
                category: nil,
                name: nil
            )
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
