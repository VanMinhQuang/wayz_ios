//
//  MapViewModel.swift
//  wayz_ios
//
//  Created by Macbook on 5/7/26.
//

import Observation

@Observable
final class MapViewModel {
    var places: [Places];
    var searchText: String;
    init() {
        self.places = Places.mockData;
        self.searchText = "";
    }
    
    
}
