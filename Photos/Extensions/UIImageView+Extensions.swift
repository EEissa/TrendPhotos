//
//  UIImageView+Extensions.swift
//  Photos
//
//  Created by Essam on 01/02/2022.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(with url: String, completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) {
        guard let _url = URL(string: url) else { return  }
        kf.indicatorType = .activity
        kf.setImage(with: _url, placeholder: nil,
                    options: [.transition(.fade(0.25))],
                    completionHandler: completionHandler)
    }
}
