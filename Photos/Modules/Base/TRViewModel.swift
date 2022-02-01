//
//  TRViewModel.swift
//  Photos
//
//  Created by Essam on 01/02/2022.
//

import RxSwift
import RxRelay

class TRViewModel {
    
    // MARK: - Variables
    let disposeBag = DisposeBag()
    let error = PublishRelay<Error>()
    let isLoading = BehaviorRelay(value: false)
}

