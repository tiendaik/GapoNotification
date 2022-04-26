//
//  ListNotificationController.swift
//  Gapo Notification
//
//  Created by Tiennh on 4/26/22.
//

import UIKit
import RxSwift

class ListNotificationController: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = ListNotificationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.getData()
    }
    
    
    override func setupRx() {
        disposeBag.addDisposables([
            self.viewModel.onDidGetNotiStart
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [unowned self] in
                    //show loading here
                }),
            self.viewModel.onDidGetNotiSuccess
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [unowned self] in
                    //check empty, loadmore, refresh,...and hide loading here
                    self.tableView.reloadData()
                }),
            self.viewModel.onDidGetNotiError
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [unowned self] err in
                    //show error message,...
                })
        ])
    }
    
    override func setupUI() {
        self.setupNavigationBar()
        
        self.tableView.register(UINib(nibName: String(describing: NotificationCell.self), bundle: nil), forCellReuseIdentifier: String(describing: NotificationCell.self))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
    }
    
    func setupNavigationBar() {
        let labelView = UILabel.init()
        labelView.text = "Thông báo"
        labelView.textColor = .black
        labelView.font = .boldSystemFont(ofSize: 28)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: labelView)
        
        let searchButton = UIButton.init()
        searchButton.setImage(UIImage.init(named: "ic_search"), for: .normal)
        searchButton.addTarget(self, action: #selector(searchNotiClicked), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: searchButton)
    }
    
    func getData() {
        self.viewModel.getNotification()
    }
    
    @objc func searchNotiClicked() {
        let searchVC = SearchNotificationController.init(nibName: String(describing: SearchNotificationController.self), bundle: nil)
        searchVC.allNotification = self.viewModel.allNotification
        self.navigationController?.pushViewController(searchVC, animated: false)
    }
    
}

extension ListNotificationController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.allNotification.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > self.viewModel.allNotification.count {
            return UITableViewCell.init()
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NotificationCell.self)) as? NotificationCell else {
            return UITableViewCell()
        }
        
        let model = self.viewModel.allNotification[indexPath.row]
        cell.bindData(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > self.viewModel.allNotification.count {
            return
        }
        let model = self.viewModel.allNotification[indexPath.row]
        model.status = .read
        self.tableView.reloadData()
    }
}
