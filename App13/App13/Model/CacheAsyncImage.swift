//
//  CacheAsyncImage.swift
//  App13
//
//  Created by Juan Andres Jaramillo on 28/10/24.
//  based on: https://github.com/pitt500/Pokedex/
//  Credits: Pedro Rojas and project authors
//  Licensed under MIT License
//

import SwiftUI

struct CacheAsyncImage<Content>: View where Content: View {

    private let url: URL
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content

    init(
        url: URL,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }

    var body: some View {

        if let cached = ImageCache[url] {
            let _ = print("cached \(url.absoluteString)")
            content(.success(cached))
        } else {
            let _ = print("request \(url.absoluteString)")
            AsyncImage(
                url: url,
                scale: scale,
                transaction: transaction
            ) { phase in
                cacheAndRender(phase: phase)
            }
        }
    }

    func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if case .success(let image) = phase {
            ImageCache[url] = image
        }

        return content(phase)
    }
}

fileprivate class ImageCache {
    static private var cache: [URL: Image] = [:]

    static subscript(url: URL) -> Image? {
        get {
            ImageCache.cache[url]
        }
        set {
            ImageCache.cache[url] = newValue
        }
    }
}

// Alternativa mas eficiente en caso de necesitar un memory management mas
// robusto (Como por ejemplo si se requiere guardar muchas mas imagenes en el cache)

//fileprivate class ImageCache {
//    // Use NSCache for better memory management
//    private static var cache = NSCache<NSURL, UIImage>()
//
//    static subscript(url: URL) -> UIImage? {
//        get {
//            ImageCache.cache.object(forKey: url as NSURL)
//        }
//        set {
//            if let image = newValue {
//                ImageCache.cache.setObject(image, forKey: url as NSURL)
//            } else {
//                ImageCache.cache.removeObject(forKey: url as NSURL)
//            }
//        }
//    }
//}
