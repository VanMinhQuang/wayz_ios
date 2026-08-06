//
//  MapViewModel.swift
//  wayz_ios
//
//  Created by Macbook on 5/7/26.
//

import Foundation
import Observation

@Observable
final class MapViewModel {
    var places: [Places] = []
    var searchText: String = ""
    var isLoading = false
    var errorMessage: String?

    private let getPlacesUseCase: GetPlacesUseCase

    init(getPlacesUseCase: GetPlacesUseCase) {
        self.getPlacesUseCase = getPlacesUseCase
    }

    func loadPlaces() async {
        isLoading = true
        errorMessage = nil
        do {
            places = try await getPlacesUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
