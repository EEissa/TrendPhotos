//
//  MockData.swift
//  PhotosTests
//
//  Created by Essam on 01/02/2022.
//

import Foundation

struct MockData {
    static var success: Data {
        let path = Bundle(for: PhotosListViewModelTests.self).path(forResource: "Response", ofType: "json")!
        return try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    }
}
