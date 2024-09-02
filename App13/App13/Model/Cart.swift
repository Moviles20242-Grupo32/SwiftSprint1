//
//  Cart.swift
//  App13
//
//  Created by Daniela Uribe on 2/09/24.
//

import SwiftUI

struct Cart: Identifiable {
    
    var id = UUID().uuidString
    var item: Item
    var quantity: Int
}


