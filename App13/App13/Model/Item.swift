//
//  Item.swift
//  App13
//
//  Created by Daniela Uribe on 29/08/24.
//

import SwiftUI

struct Item: Identifiable {
    
    var id: String
    var item_name: String
    var item_cost: NSNumber
    var item_details: String
    var item_image: String
    var item_ratings: String
    var isAdded: Bool = false
    var times_ordered: Int
}

