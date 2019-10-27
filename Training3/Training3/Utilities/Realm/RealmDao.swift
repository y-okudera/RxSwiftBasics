//
//  RealmDao.swift
//  Training3
//
//  Created by Yuki Okudera on 2019/10/27.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import RealmSwift
import RxSwift

struct RealmDao {
    
    /// Insert data
    /// - Parameter entities: Unmanaged Objects
    static func add<T: RealmSwift.Object>(entities: [T]) -> RxSwift.Completable {
        let realm = try! Realm()
        return realm.rx.asyncWrite(objects: entities)
    }
}
