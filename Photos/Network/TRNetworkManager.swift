//
//  TRNetworkManager.swift
//  Photos
//
//  Created by Essam on 01/02/2022.
//

import ESNetworkManager
import RxSwift
import Alamofire

struct TRNetworkConstants {
    static let baseUrl = "https://api.unsplash.com"
    static let accessKey = "xQGWNxZMrxQHsz6q8Dx9S_xVsWIizPrawPxOYr4EufI"
}

class NetworkManager: ESNetworkManager {
    public static var session: Session = .default
    
    override class var Manager: Session {
        return session
    }
    
    override class func map(_ response: AFDataResponse<Any>) -> ESNetworkResponse<JSON> {
        if let error = response.error {
            return .failure(error)
        }
        print(response.value ?? "No Response")
        switch response.response?.statusCode {
            case 200:
                let json = JSON(response.value)
                return .success(json)
            case let code?:
                return .failure(NSError.init(error: "unexpected status code", code: code))
                
            default:
                return .failure(NSError.init(error: "unexpected error", code: -1))
        }
    }
    
}
extension ESNetworkRequest {
    convenience init(_ path: String) {
        self.init(base: TRNetworkConstants.baseUrl, path: path)
        self.headers = ["Authorization":  "Client-ID \(TRNetworkConstants.accessKey)" ]
    }
}
