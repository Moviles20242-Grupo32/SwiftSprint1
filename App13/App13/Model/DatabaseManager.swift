//
//  Manager.swift
//  App13
//
//  Created by Daniela Uribe on 15/09/24.
//

import SwiftUI
import FirebaseFirestore

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    @Published var db: Firestore
    
    private init() {
        db = Firestore.firestore()
    } // Singleton pattern

    func fetchItems(completion: @escaping ([Item]?, Error?) -> Void) {
        
        db.collection("Items").getDocuments { (snap, err) in
            
            if let err = err {
                completion(nil, err)
                return
            }
            
            guard let itemData = snap else {
                completion(nil, nil)
                return
            }
            
            let items = itemData.documents.compactMap { (doc) -> Item? in
                
                let id = doc.documentID
                let name = doc.get("item_name") as! String
                let cost = doc.get("item_cost") as! NSNumber
                let ratings = doc.get("item_ratings") as! String
                let image = doc.get("item_image") as! String
                let details = doc.get("item_details") as! String
                
                return Item(id: id, item_name: name, item_cost: cost, item_details: details, item_image: image, item_ratings: ratings)
            }
            
            completion(items, nil)
        }
    }
    
    func deleteOrder(for userId: String, completion: @escaping (Error?) -> Void) {
            let db = Firestore.firestore()
            
            db.collection("Orders").document(userId).delete { (err) in
                completion(err)
            }
        }
        
    // Method to update/set order details
    func setOrder(for userId: String, details: [[String: Any]], totalCost: NSNumber, location: GeoPoint, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("Orders").document(userId).setData([
            "ordered_food": details,
            "total_cost": totalCost,
            "location": location
        ]) { (err) in
            completion(err)
        }
    }
}

