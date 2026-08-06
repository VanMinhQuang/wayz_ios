//
//  SeedRepositoryProtocol.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

protocol SeedRepositoryProtocol {
    func seedDemoData() async throws -> SeedResult
}
