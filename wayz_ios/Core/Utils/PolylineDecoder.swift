//
//  PolylineDecoder.swift
//  wayz_ios
//
//  Decodes the encoded polyline strings returned by MapVina's Directions API
//  (`overview_polyline.points`, `steps[].polyline.points`). Uses the standard
//  Google polyline algorithm (precision 1e5), the same format documented at
//  https://developers.google.com/maps/documentation/utilities/polylinealgorithm
//

import CoreLocation

enum PolylineDecoder {
    static func decode(_ encoded: String) -> [CLLocationCoordinate2D] {
        var coordinates: [CLLocationCoordinate2D] = []
        let chars = Array(encoded.utf8)
        var index = 0
        var lat = 0
        var lng = 0

        func decodeValue() -> Int? {
            var shift = 0
            var result = 0
            var byte: Int
            repeat {
                guard index < chars.count else { return nil }
                byte = Int(chars[index]) - 63
                index += 1
                result |= (byte & 0x1f) << shift
                shift += 5
            } while byte >= 0x20
            return (result & 1) != 0 ? ~(result >> 1) : (result >> 1)
        }

        while index < chars.count {
            guard let deltaLat = decodeValue(), let deltaLng = decodeValue() else { break }
            lat += deltaLat
            lng += deltaLng
            coordinates.append(CLLocationCoordinate2D(latitude: Double(lat) / 1e5, longitude: Double(lng) / 1e5))
        }
        return coordinates
    }
}
