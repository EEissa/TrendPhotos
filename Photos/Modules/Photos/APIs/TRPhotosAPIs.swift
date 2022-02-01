//
//  TRPhotosAPIs.swift
//  Photos
//
//  Created by Essam on 01/02/2022.
//

import ESNetworkManager
import RxSwift
import Alamofire

let PhotosPath = "/photos"
let PhotosPageLimit = 20

final class TRPhotosAPIs {
    static func loadPhotos(_ page: Int = 1) -> Single<[TRPhoto]> {
        let request = ESNetworkRequest(PhotosPath)
        request.encoding = URLEncoding.default
        request.parameters = [ "page": page, "per_page": PhotosPageLimit]
        request.method = .get
        return NetworkManager.execute(request: request)
    }
}
