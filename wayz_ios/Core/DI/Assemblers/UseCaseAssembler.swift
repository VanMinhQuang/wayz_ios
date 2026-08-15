//
//  UseCaseAssembler.swift
//  wayz_ios
//

import CoreLocation
import Swinject

/// Registers ViewModels with their Repository dependencies.
/// (Historically also registered UseCases — removed as per project convention:
/// ViewModels depend on Repository protocols directly.)
final class UseCaseAssembler: Assembly {
    func assemble(container: Container) {
        // MARK: - ViewModels

        container.register(HomeViewModel.self) { r in
            HomeViewModel(userRepository: r.resolve(UserRepositoryProtocol.self)!)
        }

        container.register(LoginViewModel.self) { r in
            LoginViewModel(userRepository: r.resolve(UserRepositoryProtocol.self)!)
        }

        container.register(ProfileViewModel.self) { r in
            ProfileViewModel(userRepository: r.resolve(UserRepositoryProtocol.self)!)
        }

        container.register(MapViewModel.self) { r in
            MapViewModel(placesRepository: r.resolve(PlacesRepositoryProtocol.self)!)
        }

        container.register(SocialTabViewModel.self) { _ in
            SocialTabViewModel()
        }

        container.register(ChatListViewModel.self) { _ in
            ChatListViewModel()
        }

        // ChatViewModel takes the target `chatId` at resolve time,
        // e.g. `DIContainer.shared.resolve(ChatViewModel.self, argument: chatId)`.
        container.register(ChatViewModel.self) { (_, chatId: String) in
            ChatViewModel(chatId: chatId)
        }

        // UserStoryViewModel takes the target `authorId` at resolve time,
        // e.g. `DIContainer.shared.resolve(UserStoryViewModel.self, argument: authorId)`.
        container.register(UserStoryViewModel.self) { (_, authorId: String) in
            UserStoryViewModel(authorId: authorId)
        }

        // NavigationViewModel takes the picked destination at resolve time,
        // e.g. `DIContainer.shared.resolve(NavigationViewModel.self, arguments: place.name, place.address, place.coordinate)`.
        container.register(NavigationViewModel.self) { (r, name: String, address: String, coordinate: CLLocationCoordinate2D) in
            NavigationViewModel(
                destinationName: name,
                destinationAddress: address,
                destinationCoordinate: coordinate,
                directionsRepository: r.resolve(DirectionsRepositoryProtocol.self)!
            )
        }
    }
}
