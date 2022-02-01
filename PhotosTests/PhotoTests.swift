//
//  PhotoTests.swift
//  PhotosTests
//
//  Created by Essam on 01/02/2022.
//

import Foundation

import XCTest
@testable import Photos

class PhotoTests: XCTestCase {
    
    var sut: TRPhoto!
    
    override func setUp() {
        super.setUp()
        sut = .init()
        sut.id = .random
    }
    
    override  func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testImage_whenChangeFavariteStatus_willChange() {
        sut.isFavorite = true
        XCTAssert(sut.isFavorite)
        
        sut.isFavorite = false
        XCTAssert(!sut.isFavorite)
    }
}
