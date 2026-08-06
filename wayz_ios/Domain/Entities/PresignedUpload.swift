//
//  PresignedUpload.swift
//  wayz_ios
//
//  Domain entity — pure Swift, no framework imports.
//

struct PresignedUpload {
    let uploadURL: String
    let key: String
    let fields: [String: String]?
}
