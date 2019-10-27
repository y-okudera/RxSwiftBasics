//
//  GourmetSearchAPIResponse.swift
//  Training3
//
//  Created by Yuki Okudera on 2019/10/26.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation

struct GourmetSearchAPIResponse: Decodable {
    let results: Results
}

struct Results: Decodable {
    let resultsReturned: String
    let resultsStart: Int
    let shop: [Shop]
}

struct Shop: Decodable {
    /// id
    let id: String
    /// 店名
    let name: String
    /// 住所
    let address: String
    /// アクセス
    let mobileAccess: String
    /// キャッチ
    let `catch`: String
    /// コースの有無
    let course: String
    /// パーキングの有無
    let parking: String
    /// 個室有無
    let privateRoom: String
    /// 禁煙席
    let nonSmoking: String
    /// 営業時間
    let open: String
    /// 定休日
    let close: String
    /// クレジットカード利用可否
    let card: String
    /// ロゴURL
    let logoImage: String
    /// 予算
    let budget: Shop.Budget
    /// クーポンURL
    let couponUrls: Shop.CouponUrls
    
    struct Budget: Decodable {
        let average: String
        let name: String
    }

    struct CouponUrls: Decodable {
        let pc: String
    }
}

extension Shop {
    init(shopEntity: ShopEntity) {
        self.id = shopEntity.shopId
        self.name = shopEntity.name
        self.address = shopEntity.address
        self.mobileAccess = shopEntity.mobileAccess
        self.catch = shopEntity.catch
        self.course = shopEntity.course
        self.parking = shopEntity.parking
        self.privateRoom = shopEntity.privateRoom
        self.nonSmoking = shopEntity.nonSmoking
        self.open = shopEntity.open
        self.close = shopEntity.close
        self.card = shopEntity.card
        self.logoImage = shopEntity.logoImage
        self.budget = Budget(average: shopEntity.budgetAverage, name: shopEntity.budgetName)
        self.couponUrls = CouponUrls(pc: shopEntity.couponUrls)
    }
}

// MARK: - Error

struct GourmetSearchAPIErrorResponse: Decodable {
    
}
