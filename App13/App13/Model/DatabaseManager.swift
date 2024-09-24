//
//  FirestoreManager.swift
//  App13
//
//  Created by Daniela Uribe on 11/09/24.
//

import SwiftUI
import FirebaseFirestore

class FirestoreManager: ObservableObject {
    static let shared = FirestoreManager() // Singleton instance
    
    @Published var db: Firestore
    
    private init() {
        db = Firestore.firestore() // Initialize Firestore instance
    }
}

