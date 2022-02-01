//
//  TRDiskCache.swift
//  Photos
//
//  Created by Essam on 01/02/2022.
//

import Kingfisher

struct TRDiskCache {
    static func cache(_ image: UIImage, forKey key: String) {
        let options: KingfisherParsedOptionsInfo = .init([.diskCacheExpiration(.never), .memoryCacheExpiration(.expired)])
        ImageCache.default.store(image,  original: nil, forKey: key, options: options)
    }
    
    static func remove(forKey key: String) {
        ImageCache.default.removeImage(forKey: key, fromMemory: false, fromDisk: true)
    }
    
    static func retrieveImage(forKey key: String, completionHandler: ((Result<ImageCacheResult, KingfisherError>) -> Void)?) {
        ImageCache.default.retrieveImage(forKey: key, completionHandler: completionHandler)
    }
}
