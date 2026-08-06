//
//  SeedRemoteDataSource.swift
//  wayz_ios
//

final class SeedRemoteDataSource {
    private let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func seedDemoData() async throws -> SeedResultDTO {
        try await client.request(.seedDemoData)
    }
}
