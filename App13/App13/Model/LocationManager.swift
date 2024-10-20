//
//  LocationManager.swift
//  App13
//
//  Created by Juan Andres Jaramillo on 16/09/24.
//

import Foundation
import CoreLocation
import Combine
import UserNotifications

// Location Manager class to manage all location related operations for the context aware system.
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // CLLocationManager instance to handle location services
    private let locationManager = CLLocationManager()
    
    // Publishes updates to user's location for SwiftUI views
    @Published var userLocation: CLLocation?
    
    // Initializes the location manager, requests permission, and starts location updates
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization() // or requestWhenInUseAuthorization(). Request location access
        locationManager.startUpdatingLocation() // Begin tracking location
    }
    
    // Updates userLocation when a new location is received
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location
    }
}
