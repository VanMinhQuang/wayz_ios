//
//  MapVinaDirectionsRemoteDataSource.swift
//  wayz_ios
//
//  Talks to MapVina's Directions v2 API to turn a start/end coordinate pair
//  into a full driving route + turn-by-turn steps.
//  https://docs.mapvina.com/vi/api-integration/directions/v2/
//

import CoreLocation
import Foundation

final class MapVinaDirectionsRemoteDataSource {
    private let baseURL = URL(string: "https://maps.mapvina.com/route/v2/directions/json")!
    private let apiKey: String
    private let session: URLSession

    init(apiKey: String = AppConfig.current.mapVinaAPIKey, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }

    func fetchRoute(from origin: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) async throws -> MapVinaRouteEntryDTO {
        guard let url = baseURL.withQuery([
            "origin": "\(origin.latitude),\(origin.longitude)",
            "destination": "\(destination.latitude),\(destination.longitude)",
            "mode": "driving",
            "key": apiKey
        ]) else {
            throw DirectionsError.invalidResponse
        }

        let data: Data
        do {
            let (responseData, _) = try await session.data(from: url)
            data = responseData
        } catch {
            throw DirectionsError.network(error)
        }

        let decoded: MapVinaDirectionsResponseDTO
        do {
            decoded = try JSONDecoder().decode(MapVinaDirectionsResponseDTO.self, from: data)
        } catch {
            throw DirectionsError.invalidResponse
        }

        guard decoded.status == "OK", let route = decoded.routes.first else {
            throw DirectionsError.noRouteFound
        }
        return route
    }
}
