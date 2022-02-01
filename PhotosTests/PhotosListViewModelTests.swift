//
//  PhotosListViewModelTests.swift
//  PhotosTests
//
//  Created by Essam on 01/02/2022.
//

import XCTest
import RxSwift
import RxTest
@testable import Photos

class PhotosListViewModelTests: XCTestCase {
    
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    var sut: TRPhotosViewModel!
    
    override func setUp() {
        super.setUp()
        disposeBag = .init()
        scheduler = .init(initialClock: 0)
        sut = .init()
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockURLProtocol.self]
        NetworkManager.session = .init(configuration: configuration)
    }
    
    override  func tearDown() {
        disposeBag = nil
        scheduler = nil
        sut = nil
        super.tearDown()
    }
    
    func testServerImagesViewModel_whenFetchData_canFetch_whenFetchData_canFetch() {
        MockURLProtocol.responseWithStatusCode(code: 200, data: MockData.success)
        let expectation = expectation(description: "Getting images")
        sut.photos.subscribe(onNext: { result in
            XCTAssertGreaterThan(result.count, 0)
            expectation.fulfill()
        }).disposed(by: disposeBag)
        
        sut.fetchImages()
        waitForExpectations(timeout: 10)
    }
    
    func testServerImagesViewModel_whenFail_willEmitError() {
        MockURLProtocol.responseWithFailure(error: NSError.init(domain: "unauthorized", code: 404, userInfo: nil))
        
        let expectation = expectation(description: "Getting error")
        
        sut.error.subscribe(onNext: { error in
            XCTAssertEqual(error.localizedDescription, "URLSessionTask failed with error: The operation couldn’t be completed. (unauthorized error 404.)")
            expectation.fulfill()
        }).disposed(by: disposeBag)
        
        sut.fetchImages()
        waitForExpectations(timeout: 10)
    }
    
    func testServerImagesViewModel_whenFetchData_isLoading() {
        MockURLProtocol.responseWithStatusCode(code: 200, data: MockData.success)
        
        let results = scheduler.createObserver(Bool.self)
        sut.isLoading.asDriver().skip(1)
            .drive(results).disposed(by: disposeBag)
        
        let expectation = expectation(description: "Getting images")
        sut.photos.subscribe(onNext: { result in
            expectation.fulfill()
        }).disposed(by: disposeBag)
        
        sut.fetchImages()
        waitForExpectations(timeout: 10)
        XCTAssertRecordedElements(results.events, [true, false])
    }
    
    func testServerImagesViewModel_whenFailToFetchingData_isLoading() {
        MockURLProtocol.responseWithStatusCode(code: 404, data: .empty)
        
        let results = scheduler.createObserver(Bool.self)
        sut.isLoading.asDriver().skip(1)
            .drive(results).disposed(by: disposeBag)
        
        let expectation = expectation(description: "Getting error")
        sut.error.subscribe{ _ in
            expectation.fulfill()
        }.disposed(by: disposeBag)
        
        sut.fetchImages()
        waitForExpectations(timeout: 10)
        XCTAssertRecordedElements(results.events, [true, false])
    }
    
}
