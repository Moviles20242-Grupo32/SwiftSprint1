//
//  User.swift
//  App13
//
//  Created by Juan Andres Jaramillo on 3/09/24.
//

import Foundation

struct User: Identifiable, Codable {
    
    let id: String
    let fullname: String
    let email: String
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname){
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        
        return ""
    }
}
