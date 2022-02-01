//
//  TDPhotosListViewController.swift
//  Photos
//
//  Created by Essam on 01/02/2022.
//

import UIKit

class TRPhotosListViewController: TRPhotosViewController  {
        
    // MARK: - Life Cycle
    init() {
        super.init(viewModel: TRPhotosViewModel())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    // MARK: - Functions
    override func setupView() {
        super.setupView()
        title = "Trend Photos"
        let barButtonItem: UIBarButtonItem  = UIBarButtonItem.init(image: UIImage.init(named: "bookmark"),
                                                                   style: .plain,
                                                                   target: self,
                                                                   action: #selector(getFavorites))
        
        barButtonItem.tintColor = .black
        navigationItem.rightBarButtonItems?.append(barButtonItem)
    }
    

    @objc fileprivate func getFavorites() {
        navigationController?.pushViewController(TRPhotosFavoritedViewController(), animated: true)
    }
    
    // MARK: - Actions
}
