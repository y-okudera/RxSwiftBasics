//
//  WeatherListViewController.swift
//  Training2
//
//  Created by Yuki Okudera on 2019/10/21.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class WeatherListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    private let disposeBag = DisposeBag()
    private let dataSource = WeatherListDataSource()
    
    lazy var viewModel = WeatherListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetch()
    }
}

extension WeatherListViewController {
    private func bind() {
        viewModel.items
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        viewModel.error
            .bind { [weak self] message in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.showError(message: message)
        }
        .disposed(by: self.disposeBag)
    }
}

extension UIViewController {
    
    func showError(message: String?) {
        let alertController = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
        alertController.addAction(.init(title: "OK", style: .default))
        self.present(alertController, animated: true)
    }
}
