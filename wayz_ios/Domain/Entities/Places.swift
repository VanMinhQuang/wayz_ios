//
//  Places.swift
//  wayz_ios
//
//  Created by Macbook on 5/7/26.
//

import CoreLocation

enum PlaceType: Int{
    case RESTAURANT = 0;
    case COFFEE = 1;
    case DRINK = 2;
    case CLUB = 3;
    case NIGHTCLUB = 4;
    case SPORT = 5;

}

    struct Places: Identifiable {
        let id: String;
        let name: String;
        let type: PlaceType;
        let description: String;
        let participants: Int;
        let rating: Int;
        let images: [String];
        let address: String;
        let timeOpen: String;
        let suitedFor: [String];
        let utilities: [String];
        let latitude: Double;
        let longitude: Double;

        var coordinate: CLLocationCoordinate2D {
            CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }


