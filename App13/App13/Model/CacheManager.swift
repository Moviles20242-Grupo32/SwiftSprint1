//
//  Cache.swift
//  App13
//
//  Created by Juan Andres Jaramillo on 17/10/24.
//

import Foundation

class CacheManager {
    static let shared = CacheManager() // Singleton instance
    
    private init() {} // Private initializer to enforce the singleton pattern
    
    private let cartCache = NSCache<NSString, Cart>() // Cache to store Cart items
    private var cartCacheKeys: [String] = [] // Array to store keys of cached items
    
    private let favoriteCache = NSCache<NSString, Item>() //Cache to store the user's favorite item.
    private var favoriteCacheKeys: [String] = [] // Array to store the key of the cached favorite item.
    
    
    

    // Add a Cart item to the cache
    func addCartItem(_ item: Cart) {
        cartCache.setObject(item, forKey: item.id as NSString)
        cartCacheKeys.append(item.id) // Track the key
        print("DEBUG: cart item added to Cache. Cache size: \(cartCacheKeys.count)")
    }
    
    // Retrieve a Cart item from the cache
    func getCartItem(byId id: String) -> Cart? {
        return cartCache.object(forKey: id as NSString)
    }
    
    // Remove a Cart item from the cache
    func removeCartItem(byId id: String) {
        cartCache.removeObject(forKey: id as NSString)
        cartCacheKeys.removeAll { $0 == id } // Remove the key from the array
        print("DEBUG: cart item removed from Cache. Cache size: \(cartCacheKeys.count)")
    }
    
    // Clear all items from the cache
    func clearCache() {
        cartCache.removeAllObjects()
        cartCacheKeys.removeAll() // Clear keys array
    }
    
    // Retrieve all items in the cache (optional)
    func getAllCartItems() -> [Cart] {
        return cartCacheKeys.compactMap { cartCache.object(forKey: $0 as NSString) }
    }
}
