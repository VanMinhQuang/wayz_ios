//
//  MapVinaRouteDTO.swift
//  wayz_ios
//
//  Response shape for MapVina's `Directions` API
//  (https://docs.mapvina.com/vi/api-integration/directions/v2/), requested
//  with `outputFormat=json`. The payload follows the Google Directions API
//  (Legacy) field layout, as documented by MapVina.
//

struct MapVinaDirectionsResponseDTO: Decodable {
    let routes: [MapVinaRouteEntryDTO]
    let status: String
}

struct MapVinaRouteEntryDTO: Decodable {
    let legs: [MapVinaLegDTO]
    let overviewPolyline: MapVinaPolylineDTO

    enum CodingKeys: String, CodingKey {
        case legs
        case overviewPolyline = "overview_polyline"
    }
}

struct MapVinaLegDTO: Decodable {
    let distance: MapVinaValueDTO
    let duration: MapVinaValueDTO
    let steps: [MapVinaStepDTO]
}

struct MapVinaStepDTO: Decodable {
    let distance: MapVinaValueDTO
    let duration: MapVinaValueDTO
    let startLocation: MapVinaLatLngDTO
    let htmlInstructions: String
    /// Present on most turn steps (e.g. "turn-right", "roundabout-left"),
    /// absent on plain "continue straight" steps — matches Google's
    /// Directions API convention that MapVina follows.
    let maneuver: String?

    enum CodingKeys: String, CodingKey {
        case distance
        case duration
        case maneuver
        case startLocation = "start_location"
        case htmlInstructions = "html_instructions"
    }
}

struct MapVinaValueDTO: Decodable {
    let value: Double
}

struct MapVinaLatLngDTO: Decodable {
    let lat: Double
    let lng: Double
}

struct MapVinaPolylineDTO: Decodable {
    let points: String
}
