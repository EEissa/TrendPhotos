//
//  TRViewController.swift
//  Photos
//
//  Created by Essam on 01/02/2022.
//

import UIKit
import RxSwift
import SnapKit

class TRViewController:  UIViewController {
    
    // MARK: - Outlets
    
    
    // MARK: - Variables
    let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    deinit {
        print("\(type(of: self)) deinit")
    }
    
    init() {
        super.init(nibName: .none, bundle: .none)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Functions
    func setupView() {
        view.backgroundColor = .white
        bindViewsToViewModel()
        bindViewModelToViews()
        setupCallbacks()
    }
    
    func bindViewsToViewModel() { }
    func bindViewModelToViews() { }
    func setupCallbacks() { }
    
    func showAlert(title : String?, message: String?) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(.init(title: "Ok", style: .destructive))
        present(alertController, animated: true, completion: nil)
    }
    
    
}
