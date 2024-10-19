//
//  CartCache.swift
//  App13
//
//  Created by Juan Andres Jaramillo on 17/10/24.
//

import Foundation

class CartCache {
    static let shared = CartCache() // Singleton instance
    
    private init() {} // Private initializer to enforce the singleton pattern
    
    private let cache = NSCache<NSString, Cart>() // Cache to store Cart items
    private var keys: [String] = [] // Array to store keys of cached items

    // Add a Cart item to the cache
    func addCartItem(_ item: Cart) {
        cache.setObject(item, forKey: item.id as NSString)
        keys.append(item.id) // Track the key
        print("DEBUG: cart item added to Cache. Cache size: \(keys.count)")
    }
    
    // Retrieve a Cart item from the cache
    func getCartItem(byId id: String) -> Cart? {
        return cache.object(forKey: id as NSString)
    }
    
    // Remove a Cart item from the cache
    func removeCartItem(byId id: String) {
        cache.removeObject(forKey: id as NSString)
        keys.removeAll { $0 == id } // Remove the key from the array
        print("DEBUG: cart item removed from Cache. Cache size: \(keys.count)")
    }
    
    // Clear all items from the cache
    func clearCache() {
        cache.removeAllObjects()
        keys.removeAll() // Clear keys array
    }
    
    // Retrieve all items in the cache (optional)
    func getAllCartItems() -> [Cart] {
        return keys.compactMap { cache.object(forKey: $0 as NSString) }
    }
}
