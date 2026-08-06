//
//  SeedDemoDataUseCase.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

final class SeedDemoDataUseCase {
    private let repository: SeedRepositoryProtocol

    init(repository: SeedRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> SeedResult {
        try await repository.seedDemoData()
    }
}
