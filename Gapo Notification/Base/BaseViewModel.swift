//
//  BaseViewModel.swift
//  Gapo Notification
//
//  Created by Tiennh on 4/26/22.
//

import Foundation
import RxSwift

class BaseViewModel {
    var disposeBag = DisposeBag()

    deinit {
        print("\(String(describing: self)) has been deinited!")
    }
}
