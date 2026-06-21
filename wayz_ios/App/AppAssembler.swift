//
//  AppAssembler.swift
//  wayz_ios
//

import Swinject

/// Root assembler that wires all DI modules together.
/// Add new Assemblers here as features grow.
final class AppAssembler {
    static let shared = AppAssembler()

    let assembler: Assembler

    private init() {
        assembler = Assembler([
            NetworkAssembler(),
            RepositoryAssembler(),
            UseCaseAssembler(),
        ])
    }
}
