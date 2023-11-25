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
    @Published var hasLocationAccess: Bool = false
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocationAccess() {
        //Only get users' location when the app is being used.
        manager.requestWhenInUseAuthorization()
    }
    
    func fetchCurrentLocation() {
        manager.requestLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
//    func locationManager (_ manager: CLLocationManager, didChangeAuthorization status:
//                          CLAuthorizationStatus) {
//        switch status {
//        case .notDetermined:
//            print ("DEBUG: Not determined")
//        case .restricted:
//            print ("DEBUG: Restricted")
//        case .denied:
//            print ("DEBUG: Denied")
//        case .authorizedAlways:
//            print ("DEBUG: Auth always")
//        case .authorizedWhenInUse:
//            print ("DEBUG: Auth when in use")
//        @unknown default:
//            break
//        }
//    }
    
    func locationManager ( _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            hasLocationAccess = false
        case .restricted:
            hasLocationAccess = false
        case .denied:
            hasLocationAccess = false
        case .authorizedAlways:
            hasLocationAccess = true
        case .authorizedWhenInUse:
            hasLocationAccess = true
        case .authorized:
            hasLocationAccess = true
        @unknown default:
            hasLocationAccess = false
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle Error
        print("Location Manager Error: \(error.localizedDescription)")
    }

}
