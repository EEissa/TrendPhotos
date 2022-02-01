//
//  PhotoViewModelTests.swift
//  PhotosTests
//
//  Created by Essam on 01/02/2022.
//

import XCTest
import RxSwift
import RxTest
import Kingfisher
@testable import Photos

class PhotoViewModelTests: XCTestCase {
    
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    var sut: TRPhotoViewModel!
    var id: String!
    var url: String!
    
    override func setUp() {
        super.setUp()
        disposeBag = .init()
        scheduler = .init(initialClock: 0)
        id = .random
        url = .random
        let photo = TRPhoto()
        photo.id = id
        photo.urlThumb = url
        sut = .init(photo: photo)
        
    }
    
    override  func tearDown() {
        disposeBag = nil
        scheduler = nil
        sut = nil
        super.tearDown()
    }
    
    func testImageViewModel_whenChangeFavoriteStatus_isFalseWhenNotMemoryCached() {
        
        let results = scheduler.createObserver(Bool.self)
        sut.isFavorite.asDriver().skip(1)
            .drive(results).disposed(by: disposeBag)
        sut.changeFavoriteStatus()
        XCTAssertRecordedElements(results.events, [false])
    }
    
    func testImageViewModel_whenChangeFavoriteStatus_isTrueWhenMemoryCached() {
        ImageCache.default.memoryStorage.store(value: UIImage(named: "favorite")!, forKey: url)
        
        let results = scheduler.createObserver(Bool.self)
        sut.isFavorite.asDriver().skip(1)
            .drive(results).disposed(by: disposeBag)
        sut.changeFavoriteStatus()
        XCTAssertRecordedElements(results.events, [true])
    }
    
    func testImageViewModel_whenChangeFavoriteStatus_isFalseWhenUnFavorite() {
        let results = scheduler.createObserver(Bool.self)
        sut.isFavorite.asDriver().skip(1)
            .drive(results).disposed(by: disposeBag)
        sut.changeFavoriteStatus()
        XCTAssertRecordedElements(results.events, [false])
    }
    
}
