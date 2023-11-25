//
//  SearchView.swift
//  Choosey
//
//  Created by Qicheng Geng on 9/27/23.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var vm = SearchViewModel()
    @ObservedObject var locationManager: LocationManager
    @State private var selectedPrice = SearchService.priceOptions[0].value
    @State private var selectedSort = SearchService.sortOptions[0].value
    
    var body: some View {
        NavigationView {
            VStack{
                List {
                    Section {
                        TextField("What is your favorite food/resturant?", text: $vm.searchTerm)
                        // A NavigationLink that links to the LocationSearchView but display the searchTerm on this row of unit of section.
                        NavigationLink(destination: LocationSearchView(searchLocation: $vm.searchLocation)){
                            Text(searchLocationTitle)
                                .foregroundColor(.primary)
                        }
                    }
                    Section {
                        Stepper("\(vm.radius) miles", value: $vm.radius, in: 1...25, step: 5)
                            .font(.headline)
                        
                        Picker("Price", selection: $vm.selectedPrice) {
                            ForEach(SearchService.priceOptions, id: \.value) { option in
                                Text(option.title).tag(option.value)
                            }
                        }                            
                            .font(.headline)

                        Picker("Sort By", selection: $vm.selectedSort) {
                            ForEach(SearchService.sortOptions, id: \.value) { option in
                                Text(option.title).tag(option.value)
                            }
                        }
                            .font(.headline)

                        Button {
                            findCurrentLocation()
                        } label: {
                            Text("Find your nearby restuarants.")
                                .fontWeight(.bold)
                                .foregroundColor(Color/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        }
                        .padding(.vertical, 5)
                    }
                    switch vm.state {
                        case .idle:
                            idleView
                        case .loading:
                            loadingView
                        case .success(let businesses):
                            Section {
                                businessList(businesses)
                            }
                        case .error(let error):
                            errorView(error)
                    }
                    
                }
            }
            .navigationTitle("Choosey")
            .background(.primary)
            .task(id: locationManager.userLocation) {
                // TODO: Immediately return if currentLocation is nil
                guard let currentLocation = locationManager.userLocation else { return }
                // TODO: Call view model method with new lat/lon
                await vm.searchBusinesses(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            }
        }
    }
    
    var searchLocationTitle: String {
        switch vm.searchLocation {
        case .current:
            return "📍 Current Location"
        case .other(let location):
            return "🗺️" + location.name
        }
    }
    
    var searchButton: some View {
        HStack {
            Spacer()

            Label("Search", systemImage: "magnifyingglass")
                .frame(alignment: .center)
                .foregroundColor(.white)

            Spacer()
        }
        .background(Color.blue)
    }
    
    func findCurrentLocation() {
        // TODO: Change vm.state. Why should we do this? What should it's value be?
        switch vm.searchLocation {
        case .current:
            locationManager.fetchCurrentLocation()
            vm.state = .loading
        case .other(let location):
            Task {
                await vm.searchBusinesses(latitude: location.latitude, longitude: location.longitude)
            }
        }
    }


    @ViewBuilder
    private var idleView: some View {
        Text("Haven't made a search request?\nIt's never too late.")
            .font(.callout)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.leading)
    }


    @ViewBuilder
    private var loadingView: some View {
        Text("BEST Choosey in a sec...")
    }

    @ViewBuilder
    private func businessList(_ businesses: [Business]) -> some View {
        ForEach(businesses){ business in
            RowView(business: business)
        }
    }

    @ViewBuilder
    private func errorView(_ error: Error) -> some View {
        Text(error.localizedDescription)
    }
}



struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        let lm = LocationManager()
        SearchView(locationManager: lm)
    }
}
