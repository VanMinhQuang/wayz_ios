//
//  PresignedUploadDTO.swift
//  wayz_ios
//

/// Response of `POST /uploads/presign` (doc §10.1): "Presigned upload
/// dictionary containing upload URL and target key parameters." The doc
/// doesn't enumerate exact keys, so this models the common presigned-POST
/// shape (upload URL + object key + any extra form fields the client must
/// echo back to the storage provider).
struct PresignedUploadDTO: Codable {
    let uploadURL: String
    let key: String
    let fields: [String: String]?

    enum CodingKeys: String, CodingKey {
        case uploadURL = "upload_url"
        case key
        case fields
    }
}
