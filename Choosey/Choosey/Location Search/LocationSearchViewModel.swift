//
//  LocationSearchViewModel.swift
//  Choosey
//
//  Created by Samuel Shi on 10/12/23.
//

import Foundation
import MapKit

// TODO: Write LocationSearchLoadingState
// - idle
// - loading
// - success, associated value called locations of type [OtherSearchLocation]
// - error, asssociated value called error of type Error
enum LocationSearchLoadingState {
    case idle
    case loading
    case success(locations: [OtherSearchLocation])
    case error(error: Error)
}

class LocationSearchViewModel: ObservableObject {
    // TODO: searchTerm published property (String, default value = "")
    @Published var searchTerm: String = ""
    // TODO: state published property (LocationSearchLoadingState, default value = .idle)
    @Published var state: LocationSearchLoadingState = .idle
    @Published var searchLocations: [OtherSearchLocation] = []

    
    func findLocations() {
        // TODO: set loading state to .loading
        self.state = .loading
        // TODO: Use MKLocalSearch to find locations for searchTerm
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchTerm
        let search = MKLocalSearch(request: searchRequest)
        // TODO: After MKLocalSearch completes (in completion handler), convert the MKMapItems to OtherSearchLocations and update loading state to either .success or .error, accordingly
        search.start { [weak self] response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.state = .error(error: error)
                    return
                }
                guard let response = response else {
                    self?.state = .error(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"]))
                    return
                }
                // Clear previous results!
                self?.searchLocations.removeAll()
                response.mapItems.forEach { item in
                    if let name = item.name, let title = item.placemark.title {
                        let newLocation = OtherSearchLocation(
                            name: name,
                            address: title,
                            latitude: item.placemark.coordinate.latitude,
                            longitude: item.placemark.coordinate.longitude
                        )
                        self?.searchLocations.append(newLocation)
                    }
                }
                if self?.searchLocations.isEmpty == true {
                    self?.state = .error(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No results found"]))
                } else {
                    self?.state = .success(locations: self?.searchLocations ?? [])
                }
            }
        }
    }
}
