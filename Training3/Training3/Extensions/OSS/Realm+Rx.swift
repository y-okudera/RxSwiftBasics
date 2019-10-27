//
//  Realm+Rx.swift
//  Training3
//
//  Created by Yuki Okudera on 2019/10/27.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

extension Realm: ReactiveCompatible {}

extension Reactive where Base: Realm {
    
    /// Write objects in background queue
    func asyncWrite(objects: [Object]) -> Completable {
        let config: Realm.Configuration = self.base.configuration
        
        return Completable.create { (observer: @escaping PrimitiveSequenceType.CompletableObserver) -> Disposable in
            DispatchQueue(label: Bundle.main.bundleIdentifier! + ".RealmSwift").async {
                autoreleasepool {
                    do {
                        let realm: Realm = try Realm(configuration: config)
                        try realm.write {
                            realm.add(objects, update: .modified)
                        }
                        observer(CompletableEvent.completed)
                    } catch {
                        observer(CompletableEvent.error(error))
                    }
                }
            }
            return Disposables.create()
        }
    }
}
