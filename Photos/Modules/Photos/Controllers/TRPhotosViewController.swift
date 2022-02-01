//
//  TRPhotosViewController.swift
//  Photos
//
//  Created by Essam on 01/02/2022.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import SKPhotoBrowser
import Kingfisher

enum DisplayMode {
    case grid
    case list
}

class TRPhotosViewController: TRViewController {
    
    // MARK: - Outlets
    let refreshControl = UIRefreshControl()
    
    var changeDisplayButton: UIButton!

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            if let layout =  collectionView.collectionViewLayout as? TRPhotosCollectionViewFlowLayout {
                layout.delegate = self
            }
            
            collectionView.refreshControl = refreshControl
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.contentInset = .init(top: 8, left: 8, bottom: 8, right: 8)
        }
    }
    
    // MARK: - Variables
    let viewModel: TRPhotosViewModel
    var photos: [TRPhoto] = []
    var currentDisplay: DisplayMode = .grid {
        didSet {
            (self.collectionView.collectionViewLayout as? TRPhotosCollectionViewFlowLayout)?.clearCache()
            self.collectionView.reloadData()
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }

    // MARK: - Life Cycle
    init(viewModel: TRPhotosViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "TRPhotosViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        KingfisherManager.shared.cache.clearMemoryCache()
    }
    
    // MARK: - Functions
    override func setupView() {
        super.setupView()
        
        changeDisplayButton = UIButton(type: .custom)
        changeDisplayButton.setImage(UIImage.init(named: "list"), for: .normal)
        changeDisplayButton.addTarget(self, action: #selector(changeDisplay), for: .touchUpInside)
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: changeDisplayButton)]

        collectionView.register(TRPhotoCollectionViewCell.self, forCellWithReuseIdentifier: TRPhotoCollectionViewCell.identifier)
        viewModel.fetchImages()
    }
    
    override func bindViewsToViewModel() {
        refreshControl.rx.controlEvent(.valueChanged).asDriver()
            .drive(onNext: viewModel.fetchImages).disposed(by: disposeBag)
    }
    
    override func bindViewModelToViews() {
        super.bindViewModelToViews()
        viewModel.isLoading.asDriver()
            .drive(refreshControl.rx.isRefreshing).disposed(by: disposeBag)
    }
    
    override func setupCallbacks() {
        super.setupCallbacks()
        viewModel.photos.subscribe(onNext: { [weak self] photos in
            guard let self = self else { return }
            self.photos = photos
            (self.collectionView.collectionViewLayout as? TRPhotosCollectionViewFlowLayout)?.clearCache()
            self.collectionView.reloadData()
            self.collectionView.collectionViewLayout.invalidateLayout()
        }).disposed(by: disposeBag)
        
        viewModel.error.subscribe(onNext: { [weak self] error in
            guard let self = self else { return }
            self.showAlert(title: "Error", message: error.localizedDescription)
        }).disposed(by: disposeBag)
    }
   
    @objc fileprivate func changeDisplay() {
        currentDisplay = currentDisplay == .list ? .grid : .list
        changeDisplayButton.setImage(currentDisplay == .grid ? UIImage(named: "list") : UIImage(named: "grid"), for: .normal)
    }
}



extension TRPhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TRPhotoCollectionViewCell.identifier, for: indexPath) as! TRPhotoCollectionViewCell
        cell.viewModel = .init(photo: photos[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = photos[indexPath.row].urlFull
        TRDiskCache.retrieveImage(forKey: url) { [weak self] result in
            guard let self = self else { return }
            let photo: SKPhoto
            if case .success(let result) = result, let image = result.image {
                photo = SKPhoto.photoWithImage(image)
                
            } else {
                photo = SKPhoto.photoWithImageURL(url)
            }
            self.present(SKPhotoBrowser(photos: [photo]), animated: true)
        }
    }
    
}

extension TRPhotosViewController: TRPhotosCollectionViewLayoutDelegate {
    func numberOfColumns(in collectionView: UICollectionView) -> Int {
        return currentDisplay == .grid ? 2 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, heightAt indexPath: IndexPath) -> CGFloat {
        let width = Int(collectionView.bounds.width)/(numberOfColumns(in: collectionView)) - 8
        let ratio = photos[indexPath.row].height/photos[indexPath.row].width
        return CGFloat(width) * CGFloat(ratio)
    }
}
