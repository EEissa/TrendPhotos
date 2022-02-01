//
//  TRPhotoViewModel.swift
//  Photos
//
//  Created by Essam on 01/02/2022.
//

import RxSwift
import RxRelay
import Kingfisher

class TRPhotoViewModel: TRPhotosViewModel {
    let isFavorite:  BehaviorRelay<Bool>
    let photo: TRPhoto
    
    init(photo: TRPhoto) {
        self.photo = photo
        self.isFavorite = .init(value: photo.isFavorite)
        super.init()
    }
    
    func changeFavoriteStatus() {
        defer {
            isFavorite.accept(photo.isFavorite)
        }
        
        guard !photo.isFavorite else {
            photo.isFavorite = false
            return TRDiskCache.remove(forKey: photo.urlThumb)
        }
        
        guard let _image = ImageCache.default.retrieveImageInMemoryCache(forKey: photo.urlThumb) else {
            return
        }
        
        photo.isFavorite = true
        TRDiskCache.cache(_image, forKey: photo.urlThumb)
    }
}
