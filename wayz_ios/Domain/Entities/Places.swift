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
        let id: String
        let name: String
        let type: PlaceType
        let description: String
        let participants: Int
        let rating: Int
        let images: [String]
        let address: String
        let timeOpen: String
        let suitedFor: [String]
        let utilities: [String]
        let latitude: Double
        let longitude: Double
        let comments: [Comment]

        // Fields present on the real `PlacePublic` API schema that don't map
        // 1:1 onto the fields above — kept alongside them rather than
        // replacing, since the Map/Profile UI still reads `type`, `rating`,
        // `timeOpen`, `suitedFor`, `utilities`, `participants` directly.
        let category: String?
        let tags: [String]
        let detail: String?
        let avgRating: Double
        let reviewCount: Int
        let createdAt: String?

        init(
            id: String,
            name: String,
            type: PlaceType,
            description: String,
            participants: Int,
            rating: Int,
            images: [String],
            address: String,
            timeOpen: String,
            suitedFor: [String],
            utilities: [String],
            latitude: Double,
            longitude: Double,
            comments: [Comment],
            category: String? = nil,
            tags: [String] = [],
            detail: String? = nil,
            avgRating: Double = 0,
            reviewCount: Int = 0,
            createdAt: String? = nil
        ) {
            self.id = id
            self.name = name
            self.type = type
            self.description = description
            self.participants = participants
            self.rating = rating
            self.images = images
            self.address = address
            self.timeOpen = timeOpen
            self.suitedFor = suitedFor
            self.utilities = utilities
            self.latitude = latitude
            self.longitude = longitude
            self.comments = comments
            self.category = category
            self.tags = tags
            self.detail = detail
            self.avgRating = avgRating
            self.reviewCount = reviewCount
            self.createdAt = createdAt
        }

        var coordinate: CLLocationCoordinate2D {
            CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }


