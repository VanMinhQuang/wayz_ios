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

                // Draw path A -> B toggle
                HStack(spacing: 8) {
                    Button(action: { isRouteVisible.toggle() }) {
                        Text(isRouteVisible ? "Hide Path A → B" : "Show Path A → B")
                            .font(.system(size: 12, weight: .medium))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                isRouteVisible
                                ? theme.colors.primary
                                : Color(UIColor.systemBackground).opacity(0.9),
                                in: Capsule()
                            )
                            .foregroundStyle(isRouteVisible ? .white : theme.colors.textPrimary)
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }

            // MARK: Selected place card (bottom)
            if let place = selectedPlace {
                VStack {
                    Spacer()
                    SelectedPlaceCard(place: place) {
                        selectedPlace = nil
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.snappy, value: selectedPlace?.id)
    }
}

// MARK: - Selected Place Card

private struct SelectedPlaceCard: View {
    let place: Places
    let onClose: () -> Void
    @Environment(\.appTheme) private var theme

    var body: some View {
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
        .padding(12)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
    }
}
