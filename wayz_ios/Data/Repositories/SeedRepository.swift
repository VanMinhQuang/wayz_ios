//
//  SeedRepository.swift
//  wayz_ios
//

final class SeedRepository: SeedRepositoryProtocol {
    private let remoteDataSource: SeedRemoteDataSource

    init(remoteDataSource: SeedRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func seedDemoData() async throws -> SeedResult {
        let dto = try await remoteDataSource.seedDemoData()
        return SeedMapper.toEntity(dto)
    }
}
