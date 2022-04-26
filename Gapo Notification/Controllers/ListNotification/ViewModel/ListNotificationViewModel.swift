//
//  ListNotificationViewModel.swift
//  Gapo Notification
//
//  Created by Tiennh on 4/26/22.
//

import Foundation
import RxSwift
import RxRelay

class ListNotificationViewModel: BaseViewModel {
    
    var allNotification = [NotificationModel]()
    private var startGetNotiDemand = PublishSubject<Void>()
    
    var onDidGetNotiStart = PublishSubject<Void>()
    var onDidGetNotiSuccess = PublishSubject<Void>()
    var onDidGetNotiError = PublishSubject<Error>()
    
    override init() {
        super.init()
        
        self.setupRx()
    }
    
    func setupRx() {
        self.disposeBag.addDisposables([
            self.startGetNotiDemand
                .do(onNext: { [unowned self] _ in
                    self.onDidGetNotiStart.onNext(())
                })
                .subscribeOn(ConcurrentDispatchQueueScheduler.globalScheduler)
                .flatMapLatest({ [unowned self] _ -> Observable<[NotificationModel]> in
                    return Observable.create { observer in
                        
                        guard let path = Bundle.main.path(forResource: "noti", ofType: "json") else {
                            let error = NSError.init(domain: "", code: 400)
                            observer.onError(error)
                            return Disposables.create()
                        }
                        do {
                            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                            if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let allNotificationDict = jsonResult["data"] as? [AnyObject], let dataArray = try? JSONSerialization.data(withJSONObject: allNotificationDict, options: []), let allNotificationData: [NotificationModel] = try? JSONDecoder().decode([NotificationModel].self, from: dataArray) {
                                observer.onNext(allNotificationData)
                                observer.onCompleted()
                            } else {
                                let error = NSError.init(domain: "", code: 500)
                                observer.onError(error)
                            }
                        } catch {
                            let error = NSError.init(domain: "", code: 500)
                            observer.onError(error)
                        }
                        
                        return Disposables.create()
                    }
                    .catchError { [unowned self] err -> Observable<[NotificationModel]> in
                        self.onDidGetNotiError.onNext(err)
                        return Observable.empty()
                    }
                })
                .do(onNext: { [unowned self] data in
                    self.allNotification = data
                    self.onDidGetNotiSuccess.onNext(())
                })
                .subscribe()
                
        ])
    }
    
    func getNotification() {
        self.startGetNotiDemand.onNext(())
    }
    
}
