//
//  MapTabView.swift
//  wayz_ios
//

import MapKit
import SwiftUI

struct MapTabView: View {
    @Environment(\.appTheme) private var theme

    // Default: Ho Chi Minh City
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 10.7769, longitude: 106.7009),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    @State private var searchText: String = ""
    @State private var selectedStyleOption: MapStyleOption = .standard

    enum MapStyleOption: String, CaseIterable {
        case standard  = "Standard"
        case satellite = "Satellite"
        case hybrid    = "Hybrid"

        var mapStyle: MapStyle {
            switch self {
            case .standard:  return .standard
            case .satellite: return .imagery
            case .hybrid:    return .hybrid
            }
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            // MARK: Map
            Map(position: $position) {
                UserAnnotation()

                // Sample friend annotations
                ForEach(MapTabView.sampleFriends) { friend in
                    Annotation(friend.name, coordinate: friend.coordinate) {
                        FriendMapPin(name: friend.name, color: friend.color)
                    }
                }
            }
            .mapStyle(selectedStyleOption.mapStyle)
            .mapControls {
                MapCompass()
                MapUserLocationButton()
                MapScaleView()
            }
            .ignoresSafeArea()

            // MARK: Top overlay
            VStack(spacing: 0) {
                // Search bar
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    TextField("Search places...", text: $searchText)
                        .font(.system(size: 15))
                }
                .padding(.horizontal, 14)
                .frame(height: 44)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 16)
                .padding(.top, 8)

                // Map style picker
                HStack(spacing: 8) {
                    ForEach(MapStyleOption.allCases, id: \.self) { option in
                        Button(action: { selectedStyleOption = option }) {
                            Text(option.rawValue)
                                .font(.system(size: 12, weight: .medium))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    selectedStyleOption == option
                                        ? theme.colors.primary
                                        : Color(UIColor.systemBackground).opacity(0.9),
                                    in: Capsule()
                                )
                                .foregroundStyle(selectedStyleOption == option ? .white : theme.colors.textPrimary)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
        }
    }

    // MARK: - Sample data

    struct FriendLocation: Identifiable {
        let id = UUID()
        let name: String
        let coordinate: CLLocationCoordinate2D
        let color: Color
    }

    static let sampleFriends: [FriendLocation] = [
        FriendLocation(name: "Alice",
                       coordinate: CLLocationCoordinate2D(latitude: 10.7800, longitude: 106.6950),
                       color: .pink),
        FriendLocation(name: "Bob",
                       coordinate: CLLocationCoordinate2D(latitude: 10.7720, longitude: 106.7100),
                       color: .orange),
        FriendLocation(name: "Quang",
                       coordinate: CLLocationCoordinate2D(latitude: 10.7750, longitude: 106.6980),
                       color: .blue)
    ]
}

// MARK: - Friend Map Pin

private struct FriendMapPin: View {
    let name: String
    let color: Color

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(color)
                    .frame(width: 40, height: 40)
                    .shadow(color: color.opacity(0.4), radius: 4, x: 0, y: 2)
                Text(String(name.prefix(1)))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
            }
            // Pin tail
            Triangle()
                .fill(color)
                .frame(width: 10, height: 6)
        }
    }
}

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: CGPoint(x: rect.midX, y: rect.maxY))
            p.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            p.closeSubpath()
        }
    }
}
