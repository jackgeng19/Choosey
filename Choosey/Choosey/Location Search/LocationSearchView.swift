//
//  LocationSearchView.swift
//  Choosey
//
//  Created by Qicheng Geng on 11/2/23.
//

import SwiftUI

struct LocationSearchView: View {
    @Environment(\.dismiss) private var dismiss: DismissAction
    @FocusState private var focused: Bool?

    // TODO: Add StateObject for our view model
    @StateObject private var vm = LocationSearchViewModel()
    @Binding var searchLocation: SearchLocationType
//    @Binding var selectedLocation: String
    

    var body: some View {
        NavigationStack {
            List {
                // TODO: Current Location Button
                // - on tap, should set binding to .current and pop back to main search view
                Section {
                    Button("Use Current Location") {
                        searchLocation = .current
                        dismiss()
                    }
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(.green) 

                }
                Section("Enter a location") {
                    TextField("Type a city for visit", text: $vm.searchTerm)
                        .focused($focused, equals: true)
                        .onAppear { focused = true }
                    Button("Search") {
                        // TODO: Start location search
                        vm.findLocations()
                    }
                    .fontWeight(.bold)
                }
                switch vm.state {
                    case .idle:
                        idleView
                    case .loading:
                        loadingView
                    case .success(let locations):
                        Section {
                            locationsList(locations)
                        }
                    case .error(let error):
                        errorView(error)
                }
                // TODO: Display different views depending on vm.state
                            // - idle: display nothing
                            // - loading: "Loading"
                            // - success: a list of the returned locations. tapping
                //            on one of these should call didSelectLocation
                //            and then pop back to the main SearchView (using dismiss)
                // - error: some text describing the error
            }
            .padding(.top, -43)
        }
        .navigationTitle("Location Search 🗺️")
        
    }
    private var idleView: some View {
        Text("Wanna explore your next station?\nLet's get it.")
            .font(.callout)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.leading)
    }


    @ViewBuilder
    private var loadingView: some View {
        Text("BEST Choosey in a sec...")
    }

    @ViewBuilder
    private func locationsList(_ locations: [OtherSearchLocation]) -> some View {
        ForEach(locations) { location in
            Button(action: {
                didSelectLocation(location)
//                selectedLocation = String(location.name)
            }) {
                VStack(alignment: .leading) {
                    Text(location.name)
                        .fontWeight(.bold)
                    Text(location.address)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
    }

    @ViewBuilder
    private func errorView(_ error: Error) -> some View {
        Text(error.localizedDescription)
    }
    
    private func didSelectLocation(_ location: OtherSearchLocation) {
        searchLocation = .other(location: location)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        LocationSearchView(searchLocation: .constant(.current))
    }
}
