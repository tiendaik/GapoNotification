//
//  RxSwift+Extension.swift
//  Gapo Notification
//
//  Created by Nguyen Huu Tien on 26/04/2022.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

extension DisposeBag {
    func addDisposables(_ array: [Disposable]) {
        for item in array {
            self.insert(item)
        }
    }
}

extension ConcurrentDispatchQueueScheduler {
    
    static var backgroundScheduler: ConcurrentDispatchQueueScheduler {
        return ConcurrentDispatchQueueScheduler(qos: .background)
    }
    
    static var globalScheduler: ConcurrentDispatchQueueScheduler {
        return ConcurrentDispatchQueueScheduler(queue: .global())
    }
}
