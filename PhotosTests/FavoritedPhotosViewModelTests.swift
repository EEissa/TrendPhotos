//
//  FavoritedPhotosViewModelTests.swift
//  PhotosTests
//
//  Created by Essam on 01/02/2022.
//

import XCTest
import RxSwift

@testable import Photos

class FavoritedPhotosViewModelTests: XCTestCase {
    
    var disposeBag: DisposeBag!
    var sut: FavoriteImagesViewModel!
    
    override func setUp() {
        super.setUp()
        disposeBag = .init()
        sut = .init()
    }
    
    override  func tearDown() {
        disposeBag = nil
        sut = nil
        super.tearDown()
    }
    
    func testFavoriteImagesViewModel_whenAddToFavorite_canFetch() {
        let id: String = .random
        let photo = TRPhoto()
        photo.id = id
        photo.urlThumb = "https://images.unsplash.com/photo-1640622842936-b81247a2d4a9?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwyOTY1OTV8MXwxfGFsbHwxfHx8fHx8Mnx8MTY0MzcwNzEwMQ&ixlib=rb-1.2.1&q=80&w=200"
        photo.width = 4000
        photo.height = 6000
        photo.isFavorite = true
        
        let expectation = expectation(description: "Getting images")
        sut.photos.subscribe(onNext: { result in
            XCTAssert(result.map(\.id).contains(id))
            expectation.fulfill()
        }).disposed(by: disposeBag)
        
        sut.fetchImages()
        waitForExpectations(timeout: 10)
    }
}
extension String {
    static var random: String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<6).map{ _ in letters.randomElement()! })
    }
}
