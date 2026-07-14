//
//  NavigationRoute.swift
//  wayz_ios
//
//  Pure domain model for a turn-by-turn driving route between two points —
//  what the guided navigation screen (NavigationView) renders and walks
//  through as the user moves.
//

import CoreLocation

/// One instruction along the route ("Turn right onto Le Loi", "Continue straight", ...).
struct NavigationStep: Identifiable, Equatable {
    let id: String
    let instruction: String
    let streetName: String
    let distanceMeters: Double
    let durationSeconds: Double
    let maneuverType: String
    let maneuverModifier: String?
    let coordinate: CLLocationCoordinate2D

    static func == (lhs: NavigationStep, rhs: NavigationStep) -> Bool {
        lhs.id == rhs.id
    }

    /// SF Symbol representing this maneuver, used in the top turn banner.
    var symbolName: String {
        switch maneuverType {
        case "depart": return "location.fill"
        case "arrive": return "mappin.circle.fill"
        case "roundabout", "rotary": return "arrow.triangle.2.circlepath"
        case "merge": return "arrow.triangle.merge"
        case "fork": return "arrow.triangle.branch"
        case "turn", "end of road", "new name", "continue":
            switch maneuverModifier {
            case "left": return "arrow.turn.up.left"
            case "sharp left": return "arrow.turn.up.left"
            case "slight left": return "arrow.up.left"
            case "right": return "arrow.turn.up.right"
            case "sharp right": return "arrow.turn.up.right"
            case "slight right": return "arrow.up.right"
            case "uturn": return "arrow.uturn.down"
            default: return "arrow.up"
            }
        default: return "arrow.up"
        }
    }
}

/// A full origin -> destination route: the geometry to draw plus the
/// step-by-step instructions to guide the user along it.
struct NavigationRoute: Equatable {
    let distanceMeters: Double
    let durationSeconds: Double
    /// Dense polyline coordinates for drawing the route line on the map.
    let coordinates: [CLLocationCoordinate2D]
    let steps: [NavigationStep]

    static func == (lhs: NavigationRoute, rhs: NavigationRoute) -> Bool {
        lhs.distanceMeters == rhs.distanceMeters &&
        lhs.durationSeconds == rhs.durationSeconds &&
        lhs.coordinates.count == rhs.coordinates.count &&
        lhs.steps == rhs.steps
    }

    var formattedDistance: String {
        distanceMeters >= 1000
            ? String(format: "%.1f km", distanceMeters / 1000)
            : String(format: "%.0f m", distanceMeters)
    }

    var formattedDuration: String {
        let minutes = max(1, Int((durationSeconds / 60).rounded()))
        if minutes < 60 { return "\(minutes) min" }
        return "\(minutes / 60) h \(minutes % 60) min"
    }

    var estimatedArrivalDate: Date {
        Date().addingTimeInterval(durationSeconds)
    }
}
