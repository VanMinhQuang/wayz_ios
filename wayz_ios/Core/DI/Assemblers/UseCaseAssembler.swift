//
//  UseCaseAssembler.swift
//  wayz_ios
//

import Swinject

final class UseCaseAssembler: Assembly {
    func assemble(container: Container) {
        // MARK: - Use Cases
        container.register(GetUserUseCase.self) { r in
            GetUserUseCase(repository: r.resolve(UserRepositoryProtocol.self)!)
        }

        container.register(LoginUseCase.self) { r in
            LoginUseCase(repository: r.resolve(UserRepositoryProtocol.self)!)
        }

        // MARK: - ViewModels
        container.register(HomeViewModel.self) { r in
            HomeViewModel(getUserUseCase: r.resolve(GetUserUseCase.self)!)
        }

        container.register(LoginViewModel.self) { r in
            LoginViewModel(loginUseCase: r.resolve(LoginUseCase.self)!)
        }

        container.register(ProfileViewModel.self) { r in
            ProfileViewModel(getUserUseCase: r.resolve(GetUserUseCase.self)!)
        }

        container.register(MapViewModel.self) { _ in
            MapViewModel()
        }
    }
}
