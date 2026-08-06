//
//  Comment.swift
//  wayz_ios
//

import Foundation

/// A photo attached to a comment: either a remote URL (seed/mock data) or
/// raw image data picked on-device by the user composing a new comment.
enum CommentImage: Identifiable {
    case remote(String)
    case local(Data)

    var id: String {
        switch self {
        case .remote(let url): return url
        case .local(let data): return data.base64EncodedString()
        }
    }
}

/// A comment on a place. Supports exactly one level of nesting via `replies`
/// — replies are plain `Comment`s but the UI never offers a "Reply" action
/// on a reply, which keeps the tree exactly two levels deep.
struct Comment: Identifiable {
    let id: String
    let authorName: String
    let authorAvatarURL: String
    let rating: Int
    let date: String
    let text: String
    let images: [String]
    let localImages: [Data]
    var replies: [Comment]

    // Fields present on the real `PlaceCommentPublic` API schema — the
    // backend has no author name/avatar/rating on a comment (those exist on
    // reviews and user profiles instead), so those UI-facing fields above are
    // best-effort/defaulted when mapping from real API data.
    let userId: String?
    let placeId: String?
    let parentId: String?
    let metaData: [String]

    init(
        id: String,
        authorName: String,
        authorAvatarURL: String,
        rating: Int = 0,
        date: String,
        text: String,
        images: [String] = [],
        localImages: [Data] = [],
        replies: [Comment] = [],
        userId: String? = nil,
        placeId: String? = nil,
        parentId: String? = nil,
        metaData: [String] = []
    ) {
        self.id = id
        self.authorName = authorName
        self.authorAvatarURL = authorAvatarURL
        self.rating = rating
        self.date = date
        self.text = text
        self.images = images
        self.localImages = localImages
        self.replies = replies
        self.userId = userId
        self.placeId = placeId
        self.parentId = parentId
        self.metaData = metaData
    }

    var allImages: [CommentImage] {
        images.map(CommentImage.remote) + localImages.map(CommentImage.local)
    }
}
