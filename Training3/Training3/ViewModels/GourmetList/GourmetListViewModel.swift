//
//  GourmetListViewModel.swift
//  Training3
//
//  Created by Yuki Okudera on 2019/10/27.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

final class GourmetListViewModel {
    
    private let disposeBag = DisposeBag()
    private let request = GourmetSearchAPIRequest(largeArea: "Z011")
    /// 飲食店データ
    private(set) var shops = BehaviorRelay<[Shop]>(value: [])
    /// エラーメッセージ
    private(set) var error = PublishRelay<String>()
    /// ローディング中かどうか
    private(set) var isLoading = BehaviorRelay<Bool>(value: false)
    
    /// グルメサーチAPIリクエスト
    func fetchShops() {
        print("fetchShops")
        isLoading.accept(true)
        request.incrementRequestPageNo()
        
        APIClient
            .request(request: request)
            .subscribe(onSuccess: { [weak self] apiResponse in
                guard let weakSelf = self else {
                    return
                }
                let shops = apiResponse.results.shop
                weakSelf.saveShopsData(shops: shops)
                weakSelf.shops.accept(weakSelf.shops.value + shops)
                weakSelf.isLoading.accept(false)
                
            }) { [weak self] error in
                guard let weakSelf = self else {
                    return
                }
                guard let apiError = error as? APIError else {
                    return
                }
                weakSelf.error.accept(apiError.message)
                weakSelf.request.decrementRequestPageNo()
                weakSelf.isLoading.accept(false)
        }
        .disposed(by: self.disposeBag)
    }
}

// MARK: - private functions
extension GourmetListViewModel {
    
    /// ShopデータをRealmに保存する
    private func saveShopsData(shops: [Shop]) {
        
        let shopEntities = shops.map { ShopEntity(shop: $0) }
        
        RealmDao
            .add(entities: shopEntities)
            .subscribe(onCompleted: {
                print("DBへの保存完了")
                
            }) { error in
                print("DBへの保存失敗: \(error)")
        }
        .disposed(by: self.disposeBag)
    }
}
