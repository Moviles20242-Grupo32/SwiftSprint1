//
//  FirestoreManager.swift
//  App13
//
//  Created by Daniela Uribe on 11/09/24.
//

import SwiftUI
import FirebaseFirestore
import Network

// DatabaseManager class to handle Firestore operations

class DatabaseManager: ObservableObject {
    
    // Singleton instance of DatabaseManager
    static let shared = DatabaseManager()
    
    // Firestore instance, wrapped with @Published to observe changes
    @Published var db: Firestore
    
    @Published var viewModel = AuthViewModel.shared
    
    // Private initializer to enforce the singleton pattern
    private init() {
        db = Firestore.firestore()
        
//        let settings = FirestoreSettings()
//        settings.isPersistenceEnabled = true // Enable offline persistence
//        db.settings = settings
    }

    // Method to fetch items from the "Items" collection in Firestore
    func fetchItems(completion: @escaping ([Item]?, Error?) -> Void) {
        
        // Fetch documents from the "Items" collection
        db.collection("Items").getDocuments { (snap, err) in
            
            // If an error occurs, return the error via completion handler
            if let err = err {
                completion(nil, err)
                return
            }
            
            // If the snapshot is nil, return nil items
            guard let itemData = snap else {
                let customError = NSError(domain: "com.example.database", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to access the Items collection."])
                completion(nil, customError)
                return
            }
            
            // Parse the document data into Item objects
            let items = itemData.documents.compactMap { (doc) -> Item? in
                
                // Extract values from the document
                let id = doc.documentID
                let name = doc.get("item_name") as! String
                let cost = doc.get("item_cost") as! NSNumber
                let ratings = doc.get("item_ratings") as! String
                let image = doc.get("item_image") as! String
                let details = doc.get("item_details") as! String
                let times = doc.get("times_ordered") as! Int
                
                // Create and return an Item object
                return Item(id: id, item_name: name, item_cost: cost, item_details: details, item_image: image, item_ratings: ratings, times_ordered: times, isAdded: false)
            }
            
            // Pass the parsed items to the completion handler
            completion(items, nil)
        }
    }
    
//func fetchItems(completion: @escaping ([Item]?, Error?) -> Void) {
//    
//    let monitor = NWPathMonitor()
//    let queue = DispatchQueue.global(qos: .background)
//    // Check network connectivity before fetching data
//    print("Im in")
//    monitor.pathUpdateHandler = { path in
//        print("Estoy en path")
//        if path.status == .satisfied {
//            print("Ya más cerca")
//            // Internet connection is available, proceed with data fetching
//            self.db.collection("Items").getDocuments { (snap, err) in
//                
//                if let err = err {
//                    completion(nil, err)
//                    return
//                }
//                
//                guard let itemData = snap else {
//                    completion(nil, nil)
//                    return
//                }
//                
//                let items = itemData.documents.compactMap { (doc) -> Item? in
//                    let id = doc.documentID
//                    let name = doc.get("item_name") as? String ?? ""
//                    let cost = doc.get("item_cost") as? NSNumber ?? 0
//                    let ratings = doc.get("item_ratings") as? String ?? ""
//                    let image = doc.get("item_image") as? String ?? ""
//                    let details = doc.get("item_details") as? String ?? ""
//                    let times = doc.get("times_ordered") as? Int ?? 0
//                    
//                    return Item(id: id, item_name: name, item_cost: cost, item_details: details, item_image: image, item_ratings: ratings, times_ordered: times)
//                }
//                completion(items, nil)
//            }
//        } else {
//            print("morí")
//            // No internet connection
//            let noInternetError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No internet connection. Please try again later."])
//            completion(nil, noInternetError)
//        }
//    }
//}
    
    
    // Method to delete an order for a specific user based on userId
    func deleteOrder(for userId: String, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("Orders").document(userId).delete { (err) in
            completion(err)
        }
    }
    
//    // Method to update/set order details
//    func setOrder(for userId: String, details: [[String: Any]], ids: [[String: Any]], totalCost: NSNumber, location: GeoPoint, completion: @escaping (Error?) -> Void) {
//        let db = Firestore.firestore()
//        
//        // Access the "Orders" collection and delete the document for the given userId
//        db.collection("Orders").document(userId).delete { (err) in
//            // Return any error encountered to the completion handler
//            completion(err)
//        }
//    }
        
    // Method to update/set order details
        func setOrder(for userId: String, details: [[String: Any]], ids: [[String: Any]], totalCost: NSNumber, location: GeoPoint, completion: @escaping (Error?) -> Void) {
            let db = Firestore.firestore()
            
            // Update or set the order details in the "Orders" collection for the userId
            db.collection("Orders").document(userId).setData([
                "ordered_food": details,
                "total_cost": totalCost,
                "location": location
            ]) { (err) in
                // Return any error encountered to the completion handler
                completion(err)
            }
            
            
            // Iterate through each item ID and update 'times_ordered'
            ids.forEach { id in
                let itemId = id["id"] as? String ?? "Unknown"
                let quantity = id["num"] as? Int ?? 0
                
                // Fetch the current 'times_ordered' value
                db.collection("Items").document(itemId).getDocument { (document, error) in
                    if let document = document, document.exists {
                        let currentTimesOrdered = document.data()?["times_ordered"] as? Int ?? 0
                        
                        // Update 'times_ordered' by adding the incoming quantity
                        db.collection("Items").document(itemId).updateData([
                            "times_ordered": currentTimesOrdered + quantity
                        ]) { err in
                            if let err = err {
                                print("Error updating times_ordered: \(err)")
                            } else {
                                print("Successfully updated times_ordered for item \(itemId)")
                            }
                        }
                    } else {
                        print("Document does not exist for item \(itemId)")
                    }
                }
            }
            
            
        }
    
    // Async method to fetch a user document from Firestore by user ID
    func fetchUser(uid: String) async throws -> User? {
        print("En Database manager" + uid)
                do {
                    // Attempt to fetch the document from Firestore
                    let snapshot = try await db.collection("users").document(uid).getDocument()

                    // Check if the document exists
                    if snapshot.exists {
                        // Log the raw data returned from Firestore
                        let data = snapshot.data()
                        print("DEBUG: Fetched user data: \(String(describing: data))")
                        
                        // Attempt to decode the document into the User object
                        return try snapshot.data(as: User.self)
                    } else {
                        // If no document exists for the given UID
                        print("DEBUG: No document found for user UID: \(uid)")
                        return nil
                    }
                } catch {
                    // Log any errors that occur during fetching or decoding
                    print("DEBUG: Error fetching user data: \(error)")
                    throw error
                }
    }

    // Async method to create a new user in the "users" collection
    func createUser(user: User) async throws {
        print("Usuario a crear")
        // Encode the User object to a Firestore-compatible format
        let encodedUser = try Firestore.Encoder().encode(user)
        // Save the encoded user data to Firestore
        try await db.collection("users").document(user.id).setData(encodedUser)
        print("Usuario creado")
    }
    
    func saveSearchUse(finalValue: String) {
        let timestamp = Timestamp()
        let data: [String: Any] = [
            "finalValue": finalValue,
            "timestamp": timestamp,
            "userId": currentUser?.id as Any
        ]

        db.collection("searchUse").addDocument(data: data) { error in
            if let error = error {
                print("Error saving search use: \(error)")
            } else {
                print("Search use successfully saved!")
            }
        }
    }

}
