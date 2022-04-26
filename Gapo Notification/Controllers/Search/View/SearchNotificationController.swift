//
//  SearchNotificationController.swift
//  Gapo Notification
//
//  Created by Tiennh on 4/26/22.
//

import UIKit
import RxSwift

class SearchNotificationController: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = SearchViewModel()
    var allNotification = [NotificationModel]()
    lazy var searchBar: UISearchBar = UISearchBar.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width - 72, height: 32))

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchBar.becomeFirstResponder()
    }

    override func setupRx() {
        self.viewModel.searchBar = self.searchBar
        self.viewModel.allNotification = self.allNotification
        self.viewModel.setupRx()
        disposeBag.addDisposables([
            self.viewModel.onDidFilterSuccess
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [unowned self] in
                    self.tableView.reloadData()
                })
        ])
    }
    
    override func setupUI() {
        self.setupNavigationBar()
        
        self.tableView.register(UINib(nibName: String(describing: NotificationCell.self), bundle: nil), forCellReuseIdentifier: String(describing: NotificationCell.self))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapTableView))
        tapGesture.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tapGesture)
    }
    
    func setupNavigationBar() {
        self.searchBar.placeholder = "Enter your text search"
        self.searchBar.searchTextField.layer.cornerRadius = self.searchBar.frame.size.height/2
        self.searchBar.searchTextField.clipsToBounds = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: self.searchBar)
        
        let closeButton = UIButton.init()
        closeButton.setImage(UIImage.init(named: "ic_close"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeSearchClicked), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: closeButton)
    }
    
    @objc func closeSearchClicked() {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func tapTableView() {
        self.searchBar.resignFirstResponder()
    }
}

extension SearchNotificationController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.shownNotification.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > self.viewModel.shownNotification.count {
            return UITableViewCell.init()
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NotificationCell.self)) as? NotificationCell else {
            return UITableViewCell()
        }
        
        let model = self.viewModel.shownNotification[indexPath.row]
        cell.bindData(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > self.viewModel.shownNotification.count {
            return
        }
        let model = self.viewModel.shownNotification[indexPath.row]
        model.status = .read
        self.tableView.reloadData()
    }
}
