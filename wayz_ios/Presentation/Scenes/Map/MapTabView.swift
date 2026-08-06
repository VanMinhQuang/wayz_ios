//
//  MapTabView.swift
//  wayz_ios
//

import CoreLocation
import SwiftUI

struct MapTabView: View {
    @Environment(\.appTheme) private var theme

    // Default: Ho Chi Minh City
    private let defaultCenter = CLLocationCoordinate2D(latitude: 10.7769, longitude: 106.7009)

    @State private var mapViewModel: MapViewModel
    @State private var isRouteVisible: Bool = false
    @State private var selectedPlace: Places?
    /// Place the user chose to navigate to — presenting this drives the
    /// full-screen guided navigation view (Google-Maps-style turn-by-turn).
    @State private var navigatingPlace: Places?
    /// "Follow my location" option set on the directions popup, carried into
    /// `NavigationGuideView` as its starting camera mode.
    @State private var startsFollowingUser = true

    /// Demo path from point A to point B. Swap in real coordinates, or a
    /// decoded polyline from a directions provider, as needed.
    private let demoRoute = MapRoute(
        start: CLLocationCoordinate2D(latitude: 10.7800, longitude: 106.6950),
        end: CLLocationCoordinate2D(latitude: 10.7720, longitude: 106.7100)
    )

    init(mapViewModel: MapViewModel) {
        self._mapViewModel = State(initialValue: mapViewModel)
    }

    /// Places filtered by the search bar, or every mock place when empty.
    private var visiblePlaces: [Places] {
        guard !mapViewModel.searchText.isEmpty else { return mapViewModel.places }
        return mapViewModel.places.filter {
            $0.name.localizedCaseInsensitiveContains(mapViewModel.searchText)
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            // MARK: Map (MapLibre + MapVina tiles)
            MapLibreMapView(
                centerCoordinate: defaultCenter,
                zoomLevel: 13,
                route: isRouteVisible ? demoRoute : nil,
                places: visiblePlaces,
                onSelectPlace: { place in
                    selectedPlace = place
                }
            )
            .ignoresSafeArea()

            // MARK: Top overlay
            VStack(spacing: 0) {
                // Search bar
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    TextField("Search places...", text: $mapViewModel.searchText)
                        .font(.system(size: 15))
                }
                .padding(.horizontal, 14)
                .frame(height: 44)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 16)
                .padding(.top, 8)

          
            }

            // MARK: Selected place card (bottom)
            if let place = selectedPlace {
                VStack {
                    Spacer()
                    SelectedPlaceCard(
                        place: place,
                        onClose: { selectedPlace = nil },
                        onNavigate: { followsLocation in
                            startsFollowingUser = followsLocation
                            navigatingPlace = place
                        }
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.snappy, value: selectedPlace?.id)
        .task { await mapViewModel.loadPlaces() }
        .fullScreenCover(item: $navigatingPlace) { place in
            NavigationGuideView(
                viewModel: DIContainer.shared.resolve(
                    NavigationViewModel.self,
                    arguments: place.name, place.address, place.coordinate
                ),
                locationManager: DIContainer.shared.resolve(LocationManager.self),
                startsFollowingUser: startsFollowingUser
            )
        }
    }
}

// MARK: - Selected Place Card

private struct SelectedPlaceCard: View {
    let place: Places
    let onClose: () -> Void
    /// Called with the "Follow my location" choice when the user taps Directions.
    let onNavigate: (Bool) -> Void
    @Environment(\.appTheme) private var theme

    /// Whether the navigation camera should follow the user once started.
    /// Defaults on, matching the Google-Maps-style guided navigation experience.
    @State private var followsLocation = true
    @State private var showSheet = false
    /// Drives the zoom transition: the detail sheet appears to burst out of
    /// the "Details" button rather than just sliding up from the bottom.
    @Namespace private var detailZoomNamespace

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: place.images.first ?? "")) { phase in
                    if let image = phase.image {
                        image.resizable().scaledToFill()
                    } else {
                        Color(UIColor.systemGray4)
                    }
                }
                .frame(width: 56, height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 4) {
                    Text(place.name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(theme.colors.textPrimary)
                    Text(place.address)
                        .font(.system(size: 12))
                        .foregroundStyle(theme.colors.textSecondary)
                        .lineLimit(1)
                }

                Spacer()

                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }

            // Option: keep the camera following the user once navigation starts.
            Toggle(isOn: $followsLocation) {
                HStack(spacing: 6) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(theme.colors.textSecondary)
                    Text("Follow my location")
                        .font(.system(size: 13))
                        .foregroundStyle(theme.colors.textSecondary)
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: theme.colors.primary))

            // Start guided, turn-by-turn navigation to this place (like Google Maps),
            // or open the full detail sheet.
            HStack(spacing: 10) {
                Button(action: { showSheet.toggle() }) {
                    HStack(spacing: 6) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 13, weight: .semibold))
                        Text("Details")
                            .font(.system(size: 15, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(theme.colors.surface, in: RoundedRectangle(cornerRadius: 12))
                    .foregroundStyle(theme.colors.textPrimary)
                }
                .matchedTransitionSource(id: "placeDetail", in: detailZoomNamespace)

                Button(action: { onNavigate(followsLocation) }) {
                    HStack(spacing: 6) {
                        Image(systemName: "location.north.fill")
                            .font(.system(size: 13, weight: .semibold))
                        Text("Directions")
                            .font(.system(size: 15, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(theme.colors.primary, in: RoundedRectangle(cornerRadius: 12))
                    .foregroundStyle(.white)
                }
            }
        }
        .sheet(isPresented: $showSheet) {
            PlaceDetailSheet(
                place: place,
                onNavigate: { onNavigate(followsLocation) },
                getPlaceCommentsUseCase: DIContainer.shared.resolve(GetPlaceCommentsUseCase.self)
            )
            .presentationDetents([.large])
            .navigationTransition(.zoom(sourceID: "placeDetail", in: detailZoomNamespace))
        }
        .padding(12)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
    }
}
