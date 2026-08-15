//
//  APIRouter.swift
//  wayz_ios
//

import Alamofire
import Foundation

/// Centralized endpoint definitions, mirroring API_DOCUMENTATION.md exactly.
/// Add a new `case` here for every API endpoint in the app.
enum APIRouter: URLRequestConvertible {

    // MARK: - Auth
    case register(email: String, username: String, password: String, fullName: String)
    case login(email: String, password: String)
    case refreshToken(token: String)

    // MARK: - Users
    case getMe
    case updateMe(body: [String: Any])
    case getPublicProfile(username: String)

    // MARK: - Social Follows
    case followUser(userId: String)
    case unfollowUser(userId: String)
    case getFollowers(userId: String)
    case getFollowing(userId: String)

    // MARK: - Block Users
    case blockUser(userId: String)
    case unblockUser(userId: String)
    case getBlockedUsers

    // MARK: - Places & Discovery
    case searchPlacesNearby(lat: Double, lng: Double, radiusM: Int?, category: String?, name: String?)
    case getPlacesByName(name: String?)
    case createPlace(body: [String: Any])
    case getPlaceDetail(placeId: String)
    case getPlaceImages(placeId: String)

    // MARK: - Place Reviews
    case getPlaceReviews(placeId: String)
    case addPlaceReview(placeId: String, rating: Int, comment: String)

    // MARK: - Place Comments
    case getPlaceComments(placeId: String)
    case addPlaceComment(placeId: String, text: String, metaData: [String], parentId: String?)

    // MARK: - Posts & Feed
    case createPost(imageURL: String, caption: String?, placeId: String?)
    case deletePost(postId: String)
    case getFeed(limit: Int)
    case getPostsByUser(userId: String, limit: Int)
    case commentOnPost(postId: String, body: String, postRefId: String?)

    // MARK: - Likes
    case likePost(postId: String)
    case unlikePost(postId: String)

    // MARK: - Stories
    case createStory(body: [String: Any])
    case deleteStory(storyId: String)
    case getStoryTray
    case getUserStories(userId: String)
    case markStoryViewed(storyId: String)
    case getStoryViewers(storyId: String)

    // MARK: - Direct Messaging
    case getConversations
    case startConversation(userId: String)
    case getMessages(conversationId: String, limit: Int)
    case sendMessage(conversationId: String, body: String)

    // MARK: - Upload Presigning
    case presignUpload(contentType: String, folder: String)

    // MARK: - Testing & Seeding
    case seedDemoData

    // MARK: - Base URL
    private var baseURL: URL {
        // swiftlint:disable force_unwrapping
        AppConfig.current.apiBaseURL
        // swiftlint:enable force_unwrapping
    }

    // MARK: - Path
    private var path: String {
        switch self {
        case .register:                        return "/auth/register"
        case .login:                            return "/auth/login"
        case .refreshToken:                     return "/auth/refresh"
        case .getMe, .updateMe:                 return "/users/me"
        case .getPublicProfile(let username):   return "/users/\(username)"
        case .followUser(let userId), .unfollowUser(let userId):
            return "/users/\(userId)/follow"
        case .getFollowers(let userId):         return "/users/\(userId)/followers"
        case .getFollowing(let userId):         return "/users/\(userId)/following"
        case .blockUser(let userId), .unblockUser(let userId):
            return "/users/\(userId)/block"
        case .getBlockedUsers:                  return "/users/me/blocked"
        case .createStory:                      return "/stories"
        case .deleteStory(let storyId):         return "/stories/\(storyId)"
        case .getStoryTray:                     return "/stories/tray"
        case .getUserStories(let userId):       return "/users/\(userId)/stories"
        case .markStoryViewed(let storyId):     return "/stories/\(storyId)/view"
        case .getStoryViewers(let storyId):     return "/stories/\(storyId)/viewers"
        case .startConversation:                return "/conversations"
        case .searchPlacesNearby, .createPlace: return "/places"
        case .getPlacesByName:                  return "/places/by_name"
        case .getPlaceDetail(let placeId):      return "/places/\(placeId)"
        case .getPlaceImages(let placeId):      return "/places/\(placeId)/images"
        case .getPlaceReviews(let placeId), .addPlaceReview(let placeId, _, _):
            return "/places/\(placeId)/reviews"
        case .getPlaceComments(let placeId), .addPlaceComment(let placeId, _, _, _):
            return "/places/\(placeId)/comments"
        case .createPost:                       return "/posts"
        case .deletePost(let postId):           return "/posts/\(postId)"
        case .getFeed:                          return "/feed"
        case .getPostsByUser(let userId, _):    return "/users/\(userId)/posts"
        case .commentOnPost(let postId, _, _):  return "/posts/\(postId)/comment"
        case .likePost(let postId), .unlikePost(let postId):
            return "/posts/\(postId)/like"
        case .getConversations:                 return "/conversations"
        case .getMessages(let conversationId, _), .sendMessage(let conversationId, _):
            return "/conversations/\(conversationId)/messages"
        case .presignUpload:                    return "/uploads/presign"
        case .seedDemoData:                     return "/seed"
        }
    }

    // MARK: - HTTP Method
    private var method: HTTPMethod {
        switch self {
        case .register, .login, .refreshToken,
             .followUser, .blockUser,
             .createPlace, .addPlaceReview, .addPlaceComment,
             .createStory, .markStoryViewed,
             .createPost, .commentOnPost, .likePost,
             .startConversation, .sendMessage,
             .presignUpload, .seedDemoData:
            return .post
        case .updateMe:
            return .patch
        case .unfollowUser, .unblockUser, .deleteStory, .deletePost, .unlikePost:
            return .delete
        case .getMe, .getPublicProfile,
             .getFollowers, .getFollowing, .getBlockedUsers,
             .searchPlacesNearby, .getPlacesByName, .getPlaceDetail, .getPlaceImages,
             .getPlaceReviews, .getPlaceComments,
             .getStoryTray, .getUserStories, .getStoryViewers,
             .getFeed, .getPostsByUser,
             .getConversations, .getMessages:
            return .get
        }
    }

    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .register(let email, let username, let password, let fullName):
            return ["email": email, "username": username, "password": password, "full_name": fullName]
        case .login(let email, let password):
            return ["email": email, "password": password]
        case .refreshToken(let token):
            return ["refresh_token": token]
        case .updateMe(let body):
            return body
        case .searchPlacesNearby(let lat, let lng, let radiusM, let category, let name):
            var params: Parameters = ["lat": lat, "lng": lng]
            if let radiusM { params["radius_m"] = radiusM }
            if let category, !category.isEmpty { params["category"] = category }
            if let name, !name.isEmpty { params["name"] = name }
            return params
        case .getPlacesByName(let name):
            guard let name, !name.isEmpty else { return nil }
            return ["name": name]
        case .createPlace(let body):
            return body
        case .addPlaceReview(_, let rating, let comment):
            return ["rating": rating, "comment": comment]
        case .addPlaceComment(_, let text, let metaData, let parentId):
            var params: Parameters = ["text": text, "meta_data": metaData]
            params["parent_id"] = parentId
            return params
        case .createPost(let imageURL, let caption, let placeId):
            var params: Parameters = ["image_url": imageURL]
            params["caption"] = caption
            params["place_id"] = placeId
            return params
        case .getFeed(let limit):
            return ["limit": limit]
        case .getPostsByUser(_, let limit):
            return ["limit": limit]
        case .commentOnPost(_, let body, let postRefId):
            var params: Parameters = ["body": body]
            params["post_ref_id"] = postRefId
            return params
        case .getMessages(_, let limit):
            return ["limit": limit]
        case .sendMessage(_, let body):
            return ["body": body]
        case .startConversation(let userId):
            return ["user_id": userId]
        case .createStory(let body):
            return body
        case .presignUpload(let contentType, let folder):
            return ["content_type": contentType, "folder": folder]
        default:
            return nil
        }
    }

    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: baseURL.appendingPathComponent(path))
        request.method = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = 30

        if let params = parameters {
            // GET/DELETE bodies aren't sent by most servers — query-encode those,
            // JSON-encode everything else (POST/PUT/PATCH bodies).
            switch method {
            case .get, .delete:
                request = try URLEncoding.default.encode(request, with: params)
            default:
                request = try JSONEncoding.default.encode(request, with: params)
            }
        }
        return request
    }
}
