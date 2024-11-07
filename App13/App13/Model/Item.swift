//
//  Item.swift
//  App13
//
//  Created by Daniela Uribe on 29/08/24.
//

import SwiftUI

class Item: Identifiable, ObservableObject {
    
    var id: String
    var item_name: String
    var item_cost: NSNumber
    var item_details: String
    var item_image: String
    var item_ratings: String
    var isAdded: Bool
    var times_ordered: Int
    var item_ingredients: String
    var item_starProducts: String
    
    init(id: String, item_name: String, item_cost: NSNumber, item_details: String, item_image: String, item_ratings: String, times_ordered: Int, isAdded: Bool, item_ingredients: String, item_starProducts: String) {
        self.id = id
        self.item_name = item_name
        self.item_cost = item_cost
        self.item_details = item_details
        self.item_image = item_image
        self.item_ratings = item_ratings
        self.times_ordered = times_ordered
        self.isAdded = isAdded
        self.item_ingredients = item_ingredients
        self.item_starProducts = item_starProducts
    }
    
    func toggleIsAdded(){
        isAdded = !isAdded
    }
}

