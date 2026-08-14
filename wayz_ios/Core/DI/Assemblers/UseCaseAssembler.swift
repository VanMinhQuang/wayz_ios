//
//  UseCaseAssembler.swift
//  wayz_ios
//

import CoreLocation
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

        container.register(RegisterUseCase.self) { r in
            RegisterUseCase(repository: r.resolve(UserRepositoryProtocol.self)!)
        }

        container.register(RefreshTokenUseCase.self) { r in
            RefreshTokenUseCase(repository: r.resolve(UserRepositoryProtocol.self)!)
        }

        container.register(UpdateMeUseCase.self) { r in
            UpdateMeUseCase(repository: r.resolve(UserRepositoryProtocol.self)!)
        }

        container.register(GetPlacesUseCase.self) { r in
            GetPlacesUseCase(repository: r.resolve(PlacesRepositoryProtocol.self)!)
        }

        container.register(SearchNearbyPlacesUseCase.self) { r in
            SearchNearbyPlacesUseCase(repository: r.resolve(PlacesRepositoryProtocol.self)!)
        }

        container.register(CreatePlaceUseCase.self) { r in
            CreatePlaceUseCase(repository: r.resolve(PlacesRepositoryProtocol.self)!)
        }

        container.register(GetPlaceDetailUseCase.self) { r in
            GetPlaceDetailUseCase(repository: r.resolve(PlacesRepositoryProtocol.self)!)
        }

        container.register(GetPlaceCommentsUseCase.self) { r in
            GetPlaceCommentsUseCase(repository: r.resolve(PlacesRepositoryProtocol.self)!)
        }

        container.register(PostPlaceCommentUseCase.self) { r in
            PostPlaceCommentUseCase(repository: r.resolve(PlacesRepositoryProtocol.self)!)
        }

        container.register(GetPlaceImagesUseCase.self) { r in
            GetPlaceImagesUseCase(repository: r.resolve(PlacesRepositoryProtocol.self)!)
        }

        container.register(GetPlaceReviewsUseCase.self) { r in
            GetPlaceReviewsUseCase(repository: r.resolve(ReviewsRepositoryProtocol.self)!)
        }

        container.register(AddPlaceReviewUseCase.self) { r in
            AddPlaceReviewUseCase(repository: r.resolve(ReviewsRepositoryProtocol.self)!)
        }

        container.register(FollowUserUseCase.self) { r in
            FollowUserUseCase(repository: r.resolve(SocialRepositoryProtocol.self)!)
        }

        container.register(UnfollowUserUseCase.self) { r in
            UnfollowUserUseCase(repository: r.resolve(SocialRepositoryProtocol.self)!)
        }

        container.register(GetFollowersUseCase.self) { r in
            GetFollowersUseCase(repository: r.resolve(SocialRepositoryProtocol.self)!)
        }

        container.register(GetFollowingUseCase.self) { r in
            GetFollowingUseCase(repository: r.resolve(SocialRepositoryProtocol.self)!)
        }

        container.register(CreatePostUseCase.self) { r in
            CreatePostUseCase(repository: r.resolve(PostsRepositoryProtocol.self)!)
        }

        container.register(DeletePostUseCase.self) { r in
            DeletePostUseCase(repository: r.resolve(PostsRepositoryProtocol.self)!)
        }

        container.register(GetFeedUseCase.self) { r in
            GetFeedUseCase(repository: r.resolve(PostsRepositoryProtocol.self)!)
        }

        container.register(GetUserPostsUseCase.self) { r in
            GetUserPostsUseCase(repository: r.resolve(PostsRepositoryProtocol.self)!)
        }

        container.register(CommentOnPostUseCase.self) { r in
            CommentOnPostUseCase(repository: r.resolve(PostsRepositoryProtocol.self)!)
        }

        container.register(LikePostUseCase.self) { r in
            LikePostUseCase(repository: r.resolve(PostsRepositoryProtocol.self)!)
        }

        container.register(UnlikePostUseCase.self) { r in
            UnlikePostUseCase(repository: r.resolve(PostsRepositoryProtocol.self)!)
        }

        container.register(GetConversationsUseCase.self) { r in
            GetConversationsUseCase(repository: r.resolve(ConversationsRepositoryProtocol.self)!)
        }

        container.register(GetMessagesUseCase.self) { r in
            GetMessagesUseCase(repository: r.resolve(ConversationsRepositoryProtocol.self)!)
        }

        container.register(SendMessageUseCase.self) { r in
            SendMessageUseCase(repository: r.resolve(ConversationsRepositoryProtocol.self)!)
        }

        container.register(PresignUploadUseCase.self) { r in
            PresignUploadUseCase(repository: r.resolve(UploadsRepositoryProtocol.self)!)
        }

        container.register(SeedDemoDataUseCase.self) { r in
            SeedDemoDataUseCase(repository: r.resolve(SeedRepositoryProtocol.self)!)
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

        container.register(MapViewModel.self) { r in
            MapViewModel(
                getPlacesUseCase: r.resolve(GetPlacesUseCase.self)!,
                searchNearbyPlacesUseCase: r.resolve(SearchNearbyPlacesUseCase.self)!
            )
        }

        container.register(SocialTabViewModel.self) { _ in
            SocialTabViewModel()
        }
        
        container.register(ChatListViewModel.self){ _ in
            ChatListViewModel()
        }
        container.register(ChatViewModel.self){_ in
            ChatViewModel()
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
