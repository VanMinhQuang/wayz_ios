//
//  NetworkAssembler.swift
//  wayz_ios
//

import Swinject

final class NetworkAssembler: Assembly {
    func assemble(container: Container) {
        container.register(APIClient.self) { _ in
            APIClient.shared
        }.inObjectScope(.container) // singleton
    }
}
