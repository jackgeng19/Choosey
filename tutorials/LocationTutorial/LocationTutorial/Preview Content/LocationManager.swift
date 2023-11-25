//
//  LocationManager.swift
//  LocationTutorial
//
//  Created by Qicheng Geng on 9/27/23.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocation?
    static let shared = LocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    func requestLocation() {
        //Only get users' location when the app is being used.
        manager.requestWhenInUseAuthorization()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager (_ manager: CLLocationManager, didChangeAuthorization status:
                          CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print ("DEBUG: Not determined")
        case .restricted:
            print ("DEBUG: Restricted")
        case .denied:
            print ("DEBUG: Denied")
        case .authorizedAlways:
            print ("DEBUG: Auth always")
        case .authorizedWhenInUse:
            print ("DEBUG: Auth when in use")
        @unknown default:
            break
        }
    }
    
    func locationManager ( _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
    }
}
