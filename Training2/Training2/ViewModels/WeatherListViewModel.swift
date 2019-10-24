//
//  WeatherListViewModel.swift
//  Training2
//
//  Created by Yuki Okudera on 2019/10/21.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

final class WeatherListViewModel: NSObject {

    private let disposeBag = DisposeBag()
    var items = BehaviorRelay<[Forecasts]>(value: [])
    var error = PublishRelay<String>()
    
    /// お天気APIリクエスト
    func fetch() {
        
        let request = WeatherForecastAPIRequest()
        
        APIClient
            .request(request: request)
            .subscribe(onSuccess: { [weak self] apiResponse in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.items.accept(apiResponse.forecasts)
                
            }) { [weak self] error in
                guard let weakSelf = self else {
                    return
                }
                guard let apiError = error as? APIError else {
                    return
                }
                weakSelf.error.accept(apiError.message)
        }
        .disposed(by: self.disposeBag)
    }
}
