//
//  HomeViewModel.swift
//  App13
//
//  Created by Daniela Uribe on 28/08/24.
//

import SwiftUI
import CoreLocation
import Firebase
import FirebaseAuth
import Foundation
import AVFoundation
import Combine

class HomeViewModel: NSObject,ObservableObject,CLLocationManagerDelegate{
    
    @Published var locationManager = CLLocationManager()
    @Published var search = ""
    
    //Location details
    @Published var userLocation : CLLocation!
    @Published var userAdress = ""
    @Published var noLocation = false
    
    //Menu
    @Published var showMenu = false
    
    //ItemData
    @Published var items: [Item] = []
    @Published var filtered: [Item] = []
    @Published var favorite: Item? = nil
    
    @Published var cartItems: [Cart] = []
    @Published var ordered = false
    
    @State private var synthesizer: AVSpeechSynthesizer?
    
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    static let shared = HomeViewModel()

    override private init() {
        super.init() // Call the super init first
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            print("autorizado")
            self.noLocation = false
            manager.requestLocation()
        case .denied:
            print("denegado")
            self.noLocation = true
        default:
            print("desconocido")
            self.noLocation = false
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userLocation = locations.last
        self.extractLocation()
        self.login()
    }
    
    func extractLocation(){
        CLGeocoder().reverseGeocodeLocation(self.userLocation){ (res, err) in
            guard let safeData = res else{return}
            
            var address = ""
            
            address += safeData.first?.name ?? ""
            address += ", "
            address += safeData.first?.locality ?? ""
            
            print(address)
            self.userAdress = address
        }
    }
    
    
    //Anonymus login for reading Database
    
    func login(){
        Auth.auth().signInAnonymously{ (res, err) in
            
            if err != nil{
                print(err!.localizedDescription)
                return
            }
            
            print("Sucess \(res!.user.uid)")
            self.fetchData()
            
        }
    }
    
    func fetchData() {
        
        guard isConnected else {
            DispatchQueue.main.async {
                // No internet connection
                self.items = []
                self.filtered = []
                self.favorite = nil
                print("No internet connection. Items, filtered, and favorite are set to nil.")
            }
            return
        }
        
        DatabaseManager.shared.fetchItems { [weak self] (items, error) in
            if let error = error {
                print("Error fetching items: \(error.localizedDescription)")
                return
            }
            
            if let items = items {
                DispatchQueue.main.async {
                    self?.items = items
                    self?.filtered = items
                    self?.favorite = self?.getFavorite()
                }
            }
        }
    }
    
    func filterData(){
        withAnimation(.linear){
            self.filtered = self.items.filter{
                return $0.item_name.lowercased().contains(self.search.lowercased())
            }
        }
    }
    
    func addToCart(item:Item){
        
//        self.items[getIndex(item: item, isCartIndex: false)].isAdded = !item.isAdded
//        
//        let filteredIndex = self.filtered.firstIndex { (item1) -> Bool in
//            return item.id == item1.id
//        } ?? 0
//        
//        self.filtered[filteredIndex].isAdded = !item.isAdded
//        
//        if item.isAdded {
//            
//            self.cartItems.remove(at: getIndex(item: item, isCartIndex: true))
//            return
//        }
//        
//        self.cartItems.append(Cart(item:item, quantity: 1))
//        print(self.cartItems)
        
        let index = getIndex(item: item, isCartIndex: false)
        let filteredIndex = self.filtered.firstIndex { (item1) -> Bool in
            return item.id == item1.id
        } ?? 0
        
        // Toggle the isAdded state
        items[index].isAdded.toggle()
        filtered[filteredIndex].isAdded.toggle()

        // Ensure favorite is updated if it's the same item
        if favorite?.id == item.id {
            favorite?.isAdded = items[index].isAdded
        }

        if items[index].isAdded {
            cartItems.append(Cart(item: items[index], quantity: 1))
        } else {
            cartItems.remove(at: getIndex(item: item, isCartIndex: true))
        }
        
    }
    
    func getIndex(item: Item, isCartIndex: Bool)->Int{
        
        let index = self.items.firstIndex{ (item1)->Bool in
            return item.id == item1.id
        } ?? 0
        
        let cartIndex = self.cartItems.firstIndex{ (item1)->Bool in
            return item.id == item1.item.id
        } ?? 0
        
        return isCartIndex ? cartIndex : index
    }

    func calculateTotalPrice()->String{
        
        var price : Float = 0
        
        cartItems.forEach {(item) in
            price += Float(item.quantity) * Float(truncating: item.item.item_cost)
        }
        
        return getPrice(value: price)
    }
    
    func getPrice(value: Float)->String{
        let format = NumberFormatter()
        format.numberStyle = .currency
        
        return format.string(from: NSNumber(value: value)) ?? ""
    }
    
    func updateOrder() {
        // Adding a delay of 1 second before executing the rest of the code
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self = self else { return }
            
            if isConnected {
                let userId = Auth.auth().currentUser!.uid
                
                if self.ordered {
                    self.ordered = false
                    
                    // Call DatabaseManager to delete the order
                    DatabaseManager.shared.deleteOrder(for: userId) { [weak self] error in
                        if let error = error {
                            print("Error deleting order: \(error)")
                            self?.ordered = true
                        }
                    }
                    
                    return
                }
                
                var details: [[String: Any]] = []
                var items_ids: [[String: Any]] = []
                
                self.cartItems.forEach { cart in
                    details.append([
                        "item_name": cart.item.item_name,
                        "item_quantity": cart.quantity,
                        "item_cost": cart.item.item_cost
                    ])
                    
                    items_ids.append([
                        "id": cart.item.id,
                        "num": cart.quantity
                    ])
                }
                
                self.ordered = true
                
                // Call DatabaseManager to set the order
                DatabaseManager.shared.setOrder(for: userId, details: details, ids: items_ids, totalCost: self.calculateTotalPrice(), location: GeoPoint(latitude: self.userLocation.coordinate.latitude, longitude: self.userLocation.coordinate.longitude)) { [weak self] error in
                    if let error = error {
                        print("Error setting order: \(error)")
                        self?.ordered = false
                    }
                }
            } else {
                self.alertMessage = "No hay conexión a internet. No se puede actualizar la orden."
                self.showAlert = true
            }
        }
    }

        
    func calculateTotalPrice() -> NSNumber {
        // Assuming there's logic here to calculate total price
        return cartItems.reduce(0) { $0 + $1.item.item_cost.floatValue * Float($1.quantity) } as NSNumber
    }
    
    func getFavorite() -> Item? {
        return items.max(by: { $0.times_ordered < $1.times_ordered })
    }

    func saveSearchUse(finalValue: String) {
        DatabaseManager.shared.saveSearchUse(finalValue: finalValue)
    }

    
}
