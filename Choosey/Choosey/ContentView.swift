//
//  ContentView.swift
//  Choosey
//
//  Created by Qicheng Geng on 9/27/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        if locationManager.hasLocationAccess {
            SearchView(locationManager: locationManager)
        } else {
            RequestLocationView(locationManager: locationManager)
        }
        
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
