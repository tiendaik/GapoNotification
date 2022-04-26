//
//  SearchViewModel.swift
//  Gapo Notification
//
//  Created by Tiennh on 4/26/22.
//

import Foundation
import RxSwift
import RxRelay

class SearchViewModel: BaseViewModel {
    var shownNotification = [NotificationModel]()
    var allNotification = [NotificationModel]()
    var searchBar: UISearchBar?
    var onDidFilterSuccess = PublishSubject<Void>()
    
    func setupRx() {
        self.searchBar?
            .rx.text
            .orEmpty
            .debounce(.microseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [unowned self] query in
                self.shownNotification = self.allNotification.filter { $0.message.text.contains(query) }
                self.onDidFilterSuccess.onNext(())
            })
            .disposed(by: disposeBag)
    }
}
