//
//  SearchViewModel.swift
//  Choosey
//
//  Created by Qicheng Geng on 9/27/23.
//

import Foundation

enum SearchLoadingState {
    case idle
    case loading
    case success(businesses: [Business])
    case error(error: Error)
}

@MainActor
class SearchViewModel: ObservableObject {
    // Inputs
    // TODO: Add searchTerm published property, default value of ""
    // TODO: Add radius published property, default value of 1
    @Published var searchTerm: String = ""
    @Published var radius: Int = 1
    @Published var state: SearchLoadingState = .idle
    @Published var selectedPrice: Int? = SearchService.priceOptions[0].value
    @Published var selectedSort:String = SearchService.sortOptions[0].value
    @Published var searchLocation: SearchLocationType = .current

        func searchBusinesses(latitude: Double, longitude: Double) async {
            do {
                self.state = .loading
                // TODO: Call SearchService's search method
                // TODO: Assign result to correct property
                let results = try await SearchService.findBusinesses(
                    latitude: latitude,
                    longitude: longitude,
                    radius: radius,
                    searchTerm: searchTerm,
                    priceOption: selectedPrice,
                    sortOption: selectedSort
                )
                self.state = .success(businesses: results)
            } catch {
                self.state = .error(error: error)
                print("Error: \(error)")
            }
    }
}
