//
//  LocationViewModel.swift
//  App13
//
//  Created by Juan Andres Jaramillo on 16/09/24.
//

import Foundation
import CoreLocation
import Combine
import UserNotifications

class LocationViewModel: ObservableObject {
    // Published properties to track user's location, proximity status, and address
    @Published var userLocation: CLLocation?
    @Published var isWithinProximity: Bool = false
    @Published var userAddress = ""
    
    // Private properties for location manager and Combine subscriptions
    private var locationManager: LocationManager
    private var cancellables = Set<AnyCancellable>()
    
    // example location (Universidad de los Andes)
    let targetLocation = CLLocation(latitude: 4.6517, longitude: -74.0549)
    
    // Initializes the view model with a LocationManager instance and starts observing location changes
    init(locationManager: LocationManager = LocationManager()) {
        self.locationManager = locationManager
        observeLocation()
//        sendTestNotification()
    }
    
//    func sendTestNotification() {
//        let content = UNMutableNotificationContent()
//        content.title = "Test Notification"
//        content.body = "This is a test notification."
//        
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//        
//        UNUserNotificationCenter.current().add(request) { error in
//            if let error = error {
//                print("Error adding notification: \(error.localizedDescription)")
//            }
//        }
//    }
    
    // Extracts user's address from their current location using reverse geocoding
    func extractLocation() {
        guard let location = self.userLocation else { return }
        
        CLGeocoder().reverseGeocodeLocation(location) { (res, err) in
            if let error = err {
                print("Error in reverse geocoding: \(error.localizedDescription)")
                return
            }
            
            guard let placemarks = res, let placemark = placemarks.first else {
                print("No address found.")
                return
            }
            
            var address = ""
            
            if let name = placemark.name {
                address += name
            }
            
            if let locality = placemark.locality {
                address += ", \(locality)"
            }
            
            self.userAddress = address
        }
    }
    
    // Observes changes to the user's location and updates proximity and address accordingly
    func observeLocation() {
        locationManager.$userLocation
            .throttle(for: .seconds(60), scheduler: DispatchQueue.main, latest: true) //checks location every 60 secs.
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                guard let self = self, let location = location else { return }
                self.userLocation = location
                self.checkProximity(userLocation: location)
                self.extractLocation()
            }
            .store(in: &cancellables)
    }
    
    // Checks if the user is within 2km of the target location and sends a notification if true
    func checkProximity(userLocation: CLLocation) {
        let distance = userLocation.distance(from: targetLocation)
        isWithinProximity = distance <= 2000
        
        if isWithinProximity {
            sendNotification()
        }
    }
    
    // Requests permission for sending notifications
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Permission granted for notifications.")
            } else if let error = error {
                print("Error requesting notifications permission: \(error)")
            }
        }
    }
    
    // Sends a notification when the user is near the target location
    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Estás cerca!"
        content.body = "Hay un restaurante Foodies a 2km de ti"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }
}


