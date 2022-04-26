//
//  BaseVC.swift
//  Gapo Notification
//
//  Created by Tiennh on 4/26/22.
//

import UIKit
import RxSwift

class BaseVC: UIViewController {
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupRx()
        self.setupUI()
    }
    
    func setupRx() {
        
    }

    func setupUI() {
        
    }

}
