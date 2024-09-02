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
    
    @Published var cartItems: [Cart] = []
    
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
    
    func fetchData(){
        let db = Firestore.firestore()
        
        db.collection("Items").getDocuments{ (snap, err) in
            
            guard let itemData = snap else{return}
            
            self.items=itemData.documents.compactMap{ (doc) -> Item? in
                
                let id = doc.documentID
                let name = doc.get("item_name") as! String
                let cost = doc.get("item_cost") as! NSNumber
                let ratings = doc.get("item_ratings") as! String
                let image = doc.get("item_image") as! String
                let details = doc.get("item_details") as! String
                
                return Item(id: id, item_name: name, item_cost: cost, item_details: details, item_image: image, item_ratings: ratings)
            }
            self.filtered = self.items
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
        
        self.items[getIndex(item: item, isCartIndex: false)].isAdded = !item.isAdded
        
        self.filtered[getIndex(item: item, isCartIndex: false)].isAdded = !item.isAdded
        
        if item.isAdded {
            
            self.cartItems.remove(at: getIndex(item: item, isCartIndex: true))
            return
        }
        
        self.cartItems.append(Cart(item:item, quantity: 1))
        
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
    
}
