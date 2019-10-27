//
//  ShopEntity.swift
//  Training3
//
//  Created by Yuki Okudera on 2019/10/27.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

final class ShopEntity: RealmSwift.Object {
    
    /// id
    @objc dynamic var shopId = ""
    /// 店名
    @objc dynamic var name = ""
    /// 住所
    @objc dynamic var address = ""
    /// アクセス
    @objc dynamic var mobileAccess = ""
    /// キャッチ
    @objc dynamic var `catch` = ""
    /// コースの有無
    @objc dynamic var course = ""
    /// パーキングの有無
    @objc dynamic var parking = ""
    /// 個室有無
    @objc dynamic var privateRoom = ""
    /// 禁煙席
    @objc dynamic var nonSmoking = ""
    /// 営業時間
    @objc dynamic var open = ""
    /// 定休日
    @objc dynamic var close = ""
    /// クレジットカード利用可否
    @objc dynamic var card = ""
    /// ロゴURL
    @objc dynamic var logoImage = ""
    
    /// 平均予算
    @objc dynamic var budgetAverage = ""
    /// 予算
    @objc dynamic var budgetName = ""
    
    /// クーポンURL
    @objc dynamic var couponUrls = ""
    
    override static func primaryKey() -> String? {
        return "shopId"
    }
    
    convenience init(shop: Shop) {
        self.init()
        self.shopId = shop.id
        self.name = shop.name
        self.address = shop.address
        self.mobileAccess = shop.mobileAccess
        self.catch = shop.catch
        self.course = shop.course
        self.parking = shop.parking
        self.privateRoom = shop.privateRoom
        self.nonSmoking = shop.nonSmoking
        self.open = shop.open
        self.close = shop.close
        self.card = shop.card
        self.logoImage = shop.logoImage
        self.budgetAverage = shop.budget.average
        self.budgetName = shop.budget.name
        self.couponUrls = shop.couponUrls.pc
    }
    
    convenience init(shopId: String,
                     name: String,
                     address: String,
                     mobileAccess: String,
                     catchString: String,
                     course: String,
                     parking: String,
                     privateRoom: String,
                     nonSmoking: String,
                     open: String,
                     close: String,
                     card: String,
                     logoImage: String,
                     budgetAverage: String,
                     budgetName: String,
                     couponUrls: String) {
        self.init()
        self.shopId = shopId
        self.name = name
        self.address = address
        self.mobileAccess = mobileAccess
        self.catch = catchString
        self.course = course
        self.parking = parking
        self.privateRoom = privateRoom
        self.nonSmoking = nonSmoking
        self.open = open
        self.close = close
        self.card = card
        self.logoImage = logoImage
        self.budgetAverage = budgetAverage
        self.budgetName = budgetName
        self.couponUrls = couponUrls
    }
}
