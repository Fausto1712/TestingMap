//
//  LocatioManager.swift
//  MapDrawer
//
//  Created by Fausto Pinto Cabrera on 02/05/24.
//

import MapKit

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()

    private var locationManager = CLLocationManager()
    @Published var lastLocation: CLLocation?

    override private init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation(completion: @escaping (CLLocation?) -> Void) {
        locationManager.startUpdatingLocation()
        completion(locationManager.location)
    }

    func requestLocation() {
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.first
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}
