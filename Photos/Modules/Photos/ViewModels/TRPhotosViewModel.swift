//
//  TRPhotosViewModel.swift
//  Photos
//
//  Created by Essam on 01/02/2022.
//

import RxSwift
import RxRelay

class TRPhotosViewModel: TRViewModel {
    var photos = PublishRelay<[TRPhoto]>()
    func fetchImages() {
        self.isLoading.accept(true)
        TRPhotosAPIs.loadPhotos().subscribe { [weak self] photos in
            guard let self = self else { return }
            self.photos.accept(photos)
            photos.forEach({ $0.saveToRealm() })
            self.isLoading.accept(false)
        } onError: { error in
            self.error.accept(error)
            if !TRPhoto.storedObjects().isEmpty { self.photos.accept(TRPhoto.storedObjects()) }
            self.isLoading.accept(false)
            
        }.disposed(by: disposeBag)
    }
}
