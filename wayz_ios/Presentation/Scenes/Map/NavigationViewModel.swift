//
//  NavigationViewModel.swift
//  wayz_ios
//
//  Drives the guided, Google-Maps-style turn-by-turn screen: fetches the
//  route once from the user's current location to a destination, then keeps
//  the "current step" / remaining distance & ETA in sync as new location
//  updates come in from `LocationManager`.
//

import CoreLocation
import Observation

@Observable
final class NavigationViewModel {
    let destinationName: String
    let destinationAddress: String
    let destinationCoordinate: CLLocationCoordinate2D

    private(set) var route: NavigationRoute?
    private(set) var isLoadingRoute = false
    private(set) var loadingMessage = "Getting your location…"
    private(set) var errorMessage: String?
    private(set) var currentStepIndex: Int = 0
    private(set) var remainingDistanceMeters: Double = 0
    private(set) var remainingDurationSeconds: Double = 0
    private(set) var hasArrived: Bool = false

    /// Last origin used to fetch a route, kept so `retry()` can re-run the
    /// same request without needing a fresh GPS fix.
    private var lastOrigin: CLLocationCoordinate2D?
    private let directionsRepository: DirectionsRepositoryProtocol
    /// Distance (meters) to a maneuver at which we consider it "reached" and advance.
    private let stepAdvanceThreshold: CLLocationDistance = 30
    private let arrivalThreshold: CLLocationDistance = 25

    init(
        destinationName: String,
        destinationAddress: String,
        destinationCoordinate: CLLocationCoordinate2D,
        directionsRepository: DirectionsRepositoryProtocol
    ) {
        self.destinationName = destinationName
        self.destinationAddress = destinationAddress
        self.destinationCoordinate = destinationCoordinate
        self.directionsRepository = directionsRepository
    }

    var currentStep: NavigationStep? { route?.steps[safe: currentStepIndex] }
    var upcomingStep: NavigationStep? { route?.steps[safe: currentStepIndex + 1] }

    var formattedRemainingDistance: String {
        remainingDistanceMeters >= 1000
            ? String(format: "%.1f km", remainingDistanceMeters / 1000)
            : String(format: "%.0f m", remainingDistanceMeters)
    }

    var formattedRemainingDuration: String {
        let minutes = max(0, Int((remainingDurationSeconds / 60).rounded()))
        if minutes < 1 { return "< 1 min" }
        if minutes < 60 { return "\(minutes) min" }
        return "\(minutes / 60) h \(minutes % 60) min"
    }

    var estimatedArrivalTime: String {
        let date = Date().addingTimeInterval(remainingDurationSeconds)
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    /// Full startup flow: waits for a real GPS fix (rather than routing from
    /// the destination to itself, which is what caused the near-guaranteed
    /// "no route found" error on first load) and then fetches the route.
    @MainActor
    func start(locationManager: LocationManager) async {
        isLoadingRoute = true
        errorMessage = nil
        loadingMessage = "Getting your location…"

        let origin = await locationManager.awaitLocation() ?? destinationCoordinate
        await loadRoute(from: origin)
    }

    /// Re-runs the last route request, e.g. from a "Retry" tap after a
    /// network or provider error.
    @MainActor
    func retry() async {
        await loadRoute(from: lastOrigin ?? destinationCoordinate)
    }

    @MainActor
    func loadRoute(from origin: CLLocationCoordinate2D) async {
        lastOrigin = origin
        isLoadingRoute = true
        loadingMessage = "Finding the best route…"
        errorMessage = nil
        do {
            let fetchedRoute = try await directionsRepository.route(from: origin, to: destinationCoordinate)
            route = fetchedRoute
            currentStepIndex = 0
            hasArrived = false
            remainingDistanceMeters = fetchedRoute.distanceMeters
            remainingDurationSeconds = fetchedRoute.durationSeconds
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoadingRoute = false
    }

    /// Advances the current step and recomputes remaining distance/ETA based
    /// on a fresh GPS fix. Call this from `.onChange(of:)` on the user's location.
    func updateProgress(userLocation: CLLocation) {
        guard let route, !route.steps.isEmpty else { return }

        while currentStepIndex < route.steps.count - 1 {
            let step = route.steps[currentStepIndex]
            let stepLocation = CLLocation(latitude: step.coordinate.latitude, longitude: step.coordinate.longitude)
            guard userLocation.distance(from: stepLocation) < stepAdvanceThreshold else { break }
            currentStepIndex += 1
        }

        let destinationLocation = CLLocation(
            latitude: destinationCoordinate.latitude,
            longitude: destinationCoordinate.longitude
        )
        remainingDistanceMeters = userLocation.distance(from: destinationLocation)
        hasArrived = remainingDistanceMeters < arrivalThreshold

        if route.distanceMeters > 0 {
            let progressRatio = min(1, max(0, remainingDistanceMeters / route.distanceMeters))
            remainingDurationSeconds = route.durationSeconds * progressRatio
        }
    }
}
