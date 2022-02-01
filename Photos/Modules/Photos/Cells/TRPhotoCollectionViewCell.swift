//
//  TRPhotoCollectionViewCell.swift
//  Photos
//
//  Created by Essam on 01/02/2022.
//

import UIKit
import RxSwift

class TRPhotoCollectionViewCell: UICollectionViewCell {
    
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        addSubview(imageView)
        sendSubviewToBack(imageView)
        imageView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        imageView.backgroundColor = .black.withAlphaComponent(0.4)
        return imageView
    }()
    
    fileprivate lazy var favoriteButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.setImage(UIImage(named: "favorite"), for: .normal)
        button.tintColor = .red
        addSubview(button)
        button.snp.makeConstraints { maker in
            maker.trailing.bottom.equalToSuperview().inset(8)
            maker.width.height.equalTo(32)
        }
        return button
    }()
    
    fileprivate(set) var disposeBag = DisposeBag()
    var viewModel: TRPhotoViewModel! {
        didSet {
            populateView()
        }
    }
    
    fileprivate func populateView() {
        viewModel.isFavorite.map({$0 ? 1 : 0.4}).asDriver(onErrorJustReturn: 0)
            .drive(favoriteButton.rx.alpha).disposed(by: disposeBag)
        
        favoriteButton.rx.tap.asDriver()
            .drive(onNext: viewModel.changeFavoriteStatus).disposed(by: disposeBag)
        
        imageView.setImage(with: viewModel.photo.urlThumb)
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
}
extension UICollectionViewCell {
    static var identifier: String {
        return .init(describing: self)
    }
}
