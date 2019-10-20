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
            .subscribe(onSuccess: { response in
                print(response)
                guard let apiResponse = response as? WeatherForecastAPIResponse else {
                    return
                }
                self.items.accept(apiResponse.forecasts)
            }) { error in
                print(error)
                guard let apiError = error as? APIError else {
                    return
                }
                self.error.accept(apiError.message)
        }
        .disposed(by: self.disposeBag)
    }
}
