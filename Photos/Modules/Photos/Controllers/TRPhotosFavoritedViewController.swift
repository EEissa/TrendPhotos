//
//  TRPhotosFavoritedViewController.swift
//  Photos
//
//  Created by Essam on 01/02/2022.
//

import UIKit

class TRPhotosFavoritedViewController: TRPhotosViewController {
    
    // MARK: - Life Cycle
    init() {
        super.init(viewModel: FavoriteImagesViewModel())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    // MARK: - Functions
    override func setupView() {
        super.setupView()
        title = "Favorites"
    }
    
    // MARK: - Actions
}
