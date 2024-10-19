//
//  User.swift
//  App13
//
//  Created by Juan Andres Jaramillo on 3/09/24.
//

import Foundation

// Class to store app-specific user Object.
struct User: Identifiable, Codable {
    
    // Properties for user ID, full name, and email
    let id: String
    let fullname: String
    let email: String
    
    // Computed property to generate user's initials from their full name
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname){
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        
        return "" // Return empty string if name components are unavailable
    }
}
