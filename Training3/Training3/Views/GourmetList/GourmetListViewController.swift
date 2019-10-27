//
//  GourmetListViewController.swift
//  Training3
//
//  Created by Yuki Okudera on 2019/10/27.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class GourmetListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    private let disposeBag = DisposeBag()
    private let dataSource = GourmetListDataSource()
    lazy var viewModel = GourmetListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        print("documentDirectory: \(documentDirectory)")
        #endif
        
        self.bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchShops()
    }
}

extension GourmetListViewController {
    
    private func bind() {
        viewModel.shops
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
        
        // distinctUntilChangedで、直前の値と異なる値が出現するまでは無視
        // withLatestFromで、viewModel.isLoadingの最新値を合成
        tableView.rx.contentOffset.asDriver()
            .map { _ in self.shouldRequestNextPage() }.distinctUntilChanged().filter { $0 }
            .withLatestFrom(viewModel.isLoading.asDriver()).filter { !$0 }
            .drive(onNext: { _ in self.viewModel.fetchShops() })
            .disposed(by: self.disposeBag)
    }
    
    private func shouldRequestNextPage() -> Bool {
        return tableView.contentSize.height > 0 && tableView.isNearBottomEdge()
    }
}
