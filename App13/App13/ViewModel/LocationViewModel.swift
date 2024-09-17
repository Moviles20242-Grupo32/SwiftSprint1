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
    @Published var userLocation: CLLocation?
    @Published var isWithinProximity: Bool = false
    @Published var userAddress = ""
    
    private var locationManager: LocationManager
    private var cancellables = Set<AnyCancellable>()
    
    let targetLocation = CLLocation(latitude: 4.6517, longitude: -74.0549) //ejemplo ubicacion
    
    init(locationManager: LocationManager = LocationManager()) {
        self.locationManager = locationManager
        observeLocation()
        sendTestNotification()
    }
    
    func sendTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Test Notification"
        content.body = "This is a test notification."
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification: \(error.localizedDescription)")
            }
        }
    }
    
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
            
            print("Extracted address: \(address)")
            self.userAddress = address
        }
    }
    
    func observeLocation() {
        locationManager.$userLocation
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                guard let self = self, let location = location else { return }
                self.userLocation = location
                self.checkProximity(userLocation: location)
                self.extractLocation()
            }
            .store(in: &cancellables)
    }
    
    func checkProximity(userLocation: CLLocation) {
        let distance = userLocation.distance(from: targetLocation)
        isWithinProximity = distance <= 2000
        
        if isWithinProximity {
            sendNotification()
        }
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Permission granted for notifications.")
            } else if let error = error {
                print("Error requesting notifications permission: \(error)")
            }
        }
    }
    
    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "You're nearby!"
        content.body = "You are within 2km of the target location."
        
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

