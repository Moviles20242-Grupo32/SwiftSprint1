//
//  Cart.swift
//  App13
//
//  Created by Daniela Uribe on 2/09/24.
//

import SwiftUI

class Cart: Identifiable, ObservableObject {
    
    var id = UUID().uuidString
    @Published var item: Item
    @Published var quantity: Int
    
    init(item: Item, quantity: Int) {
        self.item = item
        self.quantity = quantity
    }
    
    func incrementQuantity() -> Cart {
        quantity += 1
        return self
    }
    
    func decrementQuantity() -> Cart{
        quantity -= 1
        return self
    }
}


