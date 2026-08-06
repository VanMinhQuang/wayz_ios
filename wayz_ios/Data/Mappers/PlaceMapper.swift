//
//  PlaceMapper.swift
//  wayz_ios
//

enum PlaceMapper {
    /// `comments` defaults empty since place list/detail responses don't
    /// inline comments — they come from `PlacesRepositoryProtocol.fetchComments`.
    ///
    /// `PlacePublic` has no `type`/`participants`/`timeOpen`/`utilities` — those
    /// UI-facing fields are best-effort (derived from `category`/`avgRating`) or
    /// defaulted empty; the real values ride along on `category`/`tags`/`detail`/
    /// `avgRating`/`reviewCount`.
    static func toEntity(_ dto: PlaceDTO, comments: [Comment] = []) -> Places {
        Places(
            id: dto.id,
            name: dto.name,
            type: inferredType(fromCategory: dto.category),
            description: dto.description ?? "",
            participants: 0,
            rating: Int(dto.avgRating.rounded()),
            images: dto.images.sorted { $0.order < $1.order }.map(\.url),
            address: dto.address ?? "",
            timeOpen: "",
            suitedFor: dto.tags,
            utilities: [],
            latitude: dto.latitude,
            longitude: dto.longitude,
            comments: comments,
            category: dto.category,
            tags: dto.tags,
            detail: dto.detail,
            avgRating: dto.avgRating,
            reviewCount: dto.reviewCount,
            createdAt: dto.createdAt
        )
    }

    private static func inferredType(fromCategory category: String?) -> PlaceType {
        switch category?.lowercased() {
        case "restaurant":              return .RESTAURANT
        case "cafe", "coffee":          return .COFFEE
        case "bar", "drink", "drinks":  return .DRINK
        case "club":                    return .CLUB
        case "nightclub":               return .NIGHTCLUB
        case "sport", "sports":         return .SPORT
        default:                        return .RESTAURANT
        }
    }
}
