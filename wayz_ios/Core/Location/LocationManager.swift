//
//  LocationManager.swift
//  wayz_ios
//
//  Thin CLLocationManager wrapper exposing the user's live location + heading
//  as @Observable state, so SwiftUI views (map, navigation guide) can react
//  to it directly without dealing with delegate callbacks themselves.
//

import CoreLocation
import Observation

@Observable
final class LocationManager: NSObject {
    private let manager = CLLocationManager()

    /// Latest known user location. `nil` until the first fix arrives.
    private(set) var currentLocation: CLLocation?
    /// Compass/course heading in degrees, used to rotate the map + arrow in navigation mode.
    private(set) var heading: CLLocationDirection?
    private(set) var authorizationStatus: CLAuthorizationStatus

    override init() {
        self.authorizationStatus = manager.authorizationStatus
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.activityType = .automotiveNavigation
        manager.distanceFilter = 5 // meters
    }

    func requestAuthorization() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            break
        }
    }

    func startUpdating() {
        requestAuthorization()
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
    }

    func stopUpdating() {
        manager.stopUpdatingLocation()
        manager.stopUpdatingHeading()
    }

    /// Waits for a first GPS fix, polling `currentLocation` up to `timeout`
    /// seconds. Returns `nil` if no fix arrives in time (e.g. permission
    /// denied, GPS unavailable) so callers can fall back gracefully instead
    /// of silently routing from the destination to itself.
    func awaitLocation(timeout: TimeInterval = 5) async -> CLLocationCoordinate2D? {
        if let coordinate = currentLocation?.coordinate { return coordinate }

        let pollInterval: UInt64 = 200_000_000 // 0.2s
        let deadline = Date().addingTimeInterval(timeout)
        while Date() < deadline {
            try? await Task.sleep(nanoseconds: pollInterval)
            if let coordinate = currentLocation?.coordinate { return coordinate }
        }
        return currentLocation?.coordinate
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            manager.startUpdatingLocation()
            manager.startUpdatingHeading()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latest = locations.last else { return }
        currentLocation = latest
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading.trueHeading >= 0 ? newHeading.trueHeading : newHeading.magneticHeading
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Non-fatal: keep last known location, allow the UI to show a retry state if needed.
    }
}
