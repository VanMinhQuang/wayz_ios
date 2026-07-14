//
//  NavigationRouteMapper.swift
//  wayz_ios
//

import CoreLocation

enum NavigationRouteMapper {
    static func toEntity(_ dto: MapVinaRouteEntryDTO) -> NavigationRoute {
        let coordinates = PolylineDecoder.decode(dto.overviewPolyline.points)
        let allSteps = dto.legs.flatMap { $0.steps }

        let distanceMeters = dto.legs.reduce(0) { $0 + $1.distance.value }
        let durationSeconds = dto.legs.reduce(0) { $0 + $1.duration.value }

        let steps = allSteps.enumerated().map { index, step -> NavigationStep in
            let coordinate = CLLocationCoordinate2D(latitude: step.startLocation.lat, longitude: step.startLocation.lng)
            let instruction = stripHTML(step.htmlInstructions)
            let streetName = boldText(in: step.htmlInstructions) ?? instruction
            let (maneuverType, maneuverModifier) = normalizeManeuver(
                step.maneuver,
                isFirst: index == 0,
                isLast: index == allSteps.count - 1
            )

            return NavigationStep(
                id: "\(index)-\(step.maneuver ?? maneuverType)-\(step.startLocation.lat),\(step.startLocation.lng)",
                instruction: instruction,
                streetName: streetName,
                distanceMeters: step.distance.value,
                durationSeconds: step.duration.value,
                maneuverType: maneuverType,
                maneuverModifier: maneuverModifier,
                coordinate: coordinate
            )
        }

        return NavigationRoute(
            distanceMeters: distanceMeters,
            durationSeconds: durationSeconds,
            coordinates: coordinates,
            steps: steps
        )
    }

    /// MapVina follows Google's Directions API `maneuver` convention: a single
    /// hyphenated string (e.g. "turn-slight-left", "roundabout-right",
    /// "uturn-left"), omitted entirely for plain "continue straight" steps,
    /// and for the first/last steps of a route. This maps that vocabulary
    /// onto the OSRM-style `(type, modifier)` pair `NavigationStep` expects.
    private static func normalizeManeuver(_ raw: String?, isFirst: Bool, isLast: Bool) -> (type: String, modifier: String?) {
        guard let raw, !raw.isEmpty else {
            if isFirst { return ("depart", nil) }
            if isLast { return ("arrive", nil) }
            return ("continue", nil)
        }

        var parts = raw.split(separator: "-").map(String.init)
        let head = parts.removeFirst()
        let modifier = parts.isEmpty ? nil : parts.joined(separator: " ")

        switch head {
        case "turn":
            return ("turn", modifier ?? "straight")
        case "uturn":
            return ("turn", "uturn")
        case "roundabout", "rotary":
            return ("roundabout", modifier)
        case "merge":
            return ("merge", modifier)
        case "fork", "keep", "ramp":
            return ("fork", modifier)
        default:
            return ("continue", modifier)
        }
    }

    private static func stripHTML(_ html: String) -> String {
        html.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
            .replacingOccurrences(of: "&nbsp;", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Extracts the text inside the first `<b>...</b>` tag, which MapVina/Google
    /// use to highlight the street or place name within `html_instructions`.
    private static func boldText(in html: String) -> String? {
        guard let range = html.range(of: "<b>(.*?)</b>", options: .regularExpression) else { return nil }
        return stripHTML(String(html[range]))
    }
}
