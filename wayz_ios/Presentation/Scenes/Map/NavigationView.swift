//
//  NavigationView.swift
//  wayz_ios
//
//  Full-screen, Google-Maps-style guided navigation: a route line + a
//  heading-following camera, a top "next turn" banner, and a bottom ETA bar
//  with an End button. Presented as a `fullScreenCover` from the map once
//  the user picks "Start" on a route preview.
//

import CoreLocation
import MapLibre
import SwiftUI
import UIKit

struct NavigationGuideView: View {
    @Environment(\.appTheme) private var theme
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: NavigationViewModel
    private let locationManager: LocationManager
    /// Whether the camera should keep following the user's location/heading.
    /// Seeded from the "Follow my location" option the user set on the
    /// directions popup before starting; dropped to `false` if the user
    /// manually pans/rotates the map, at which point a "recenter" button
    /// lets them opt back in.
    @State private var isFollowingUser: Bool

    init(viewModel: NavigationViewModel, locationManager: LocationManager, startsFollowingUser: Bool = true) {
        self._viewModel = State(initialValue: viewModel)
        self.locationManager = locationManager
        self._isFollowingUser = State(initialValue: startsFollowingUser)
    }

    private var mapCenter: CLLocationCoordinate2D {
        locationManager.currentLocation?.coordinate ?? viewModel.destinationCoordinate
    }

    private var mapRoute: MapRoute? {
        guard let route = viewModel.route, let start = route.coordinates.first else { return nil }
        return MapRoute(start: start, end: viewModel.destinationCoordinate, pathCoordinates: route.coordinates)
    }

    var body: some View {
        ZStack(alignment: .top) {
            MapLibreMapView(
                centerCoordinate: mapCenter,
                zoomLevel: 17,
                route: mapRoute,
                lineColor: UIColor(theme.colors.primary),
                lineWidth: 6,
                showsUserLocation: true,
                userTrackingMode: isFollowingUser ? .followWithHeading : .none,
                navigationPitch: 55,
                onUserTrackingModeChange: { mode in
                    isFollowingUser = mode != .none
                }
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                turnBanner
                Spacer()
                HStack {
                    Spacer()
                    recenterButton
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
                bottomBar
            }
        }
        .task {
            locationManager.startUpdating()
            await viewModel.start(locationManager: locationManager)
        }
        .onDisappear {
            locationManager.stopUpdating()
        }
        .onChange(of: locationManager.currentLocation?.timestamp) { _, _ in
            guard let location = locationManager.currentLocation else { return }
            viewModel.updateProgress(userLocation: location)
        }
        .statusBarHidden()
    }

    // MARK: - Turn banner

    @ViewBuilder
    private var turnBanner: some View {
        Group {
            if let step = viewModel.currentStep {
                HStack(spacing: 14) {
                    Image(systemName: step.symbolName)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 52, height: 52)
                        .background(theme.colors.primary, in: RoundedRectangle(cornerRadius: 14))

                    VStack(alignment: .leading, spacing: 2) {
                        Text(formattedDistance(step.distanceMeters))
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(theme.colors.textPrimary)
                        Text(step.instruction)
                            .font(.system(size: 14))
                            .foregroundStyle(theme.colors.textSecondary)
                            .lineLimit(2)
                    }

                    Spacer()

                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(.secondary)
                            .padding(8)
                            .background(Color(UIColor.systemGray5), in: Circle())
                    }
                }
                .padding(14)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 18))
                .shadow(color: .black.opacity(0.15), radius: 10, y: 4)
                .padding(.horizontal, 12)
                .padding(.top, 8)
            } else if viewModel.isLoadingRoute {
                statusPill {
                    ProgressView()
                    Text(viewModel.loadingMessage)
                        .font(.system(size: 14))
                }
            } else if let error = viewModel.errorMessage {
                statusPill {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(theme.colors.error)
                    Text(error)
                        .font(.system(size: 13))
                        .lineLimit(2)
                    Button(action: { Task { await viewModel.retry() } }) {
                        Text("Retry")
                            .font(.system(size: 13, weight: .semibold))
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func statusPill<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        HStack(spacing: 10) {
            content()
        }
        .padding(14)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
        .padding(.horizontal, 12)
        .padding(.top, 8)
    }

    // MARK: - Recenter control

    @ViewBuilder
    private var recenterButton: some View {
        if !isFollowingUser {
            Button(action: {
                withAnimation(.snappy) { isFollowingUser = true }
            }) {
                Image(systemName: "location.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(theme.colors.primary)
                    .frame(width: 46, height: 46)
                    .background(.regularMaterial, in: Circle())
                    .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
            }
            .transition(.scale.combined(with: .opacity))
        }
    }

    // MARK: - Bottom ETA bar

    private var bottomBar: some View {
        VStack(spacing: 12) {
            if viewModel.hasArrived {
                VStack(spacing: 4) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(theme.colors.primary)
                    Text("You've arrived at \(viewModel.destinationName)")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(theme.colors.textPrimary)
                }
            } else {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(viewModel.formattedRemainingDuration)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(theme.colors.primary)
                        Text("\(viewModel.formattedRemainingDistance) · arrive \(viewModel.estimatedArrivalTime)")
                            .font(.system(size: 13))
                            .foregroundStyle(theme.colors.textSecondary)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("To")
                            .font(.system(size: 11))
                            .foregroundStyle(theme.colors.textSecondary)
                        Text(viewModel.destinationName)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(theme.colors.textPrimary)
                            .lineLimit(1)
                    }
                }
            }

            Button(action: { dismiss() }) {
                Text(viewModel.hasArrived ? "Done" : "End Navigation")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(theme.colors.error, in: RoundedRectangle(cornerRadius: 14))
                    .foregroundStyle(.white)
            }
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.15), radius: 12, y: -2)
        .padding(.horizontal, 12)
        .padding(.bottom, 12)
    }

    private func formattedDistance(_ meters: Double) -> String {
        meters >= 1000
            ? String(format: "%.1f km", meters / 1000)
            : String(format: "%.0f m", meters)
    }
}
