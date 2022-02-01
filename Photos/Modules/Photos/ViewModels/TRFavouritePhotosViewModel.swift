//
//  TRFavouritePhotosViewController.swift
//  Photos
//
//  Created by Essam on 01/02/2022.
//

import RealmSwift

class FavoriteImagesViewModel: TRPhotosViewModel {
    override func fetchImages() {
        photos.accept(TRPhoto.storedObjects(NSPredicate(format: "favorited = true", "")))
        self.isLoading.accept(false)
    }
}
