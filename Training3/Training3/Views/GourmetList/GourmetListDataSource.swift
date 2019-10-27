//
//  GourmetListDataSource.swift
//  Training3
//
//  Created by Yuki Okudera on 2019/10/27.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class GourmetListDataSource: NSObject {
    typealias Element = [Shop]
    var _itemModels: [Shop] = []
}

// MARK: UITableViewDataSource
extension GourmetListDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _itemModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopTableViewCell", for: indexPath) as! ShopTableViewCell
        let element = _itemModels[indexPath.row]
        cell.shop = element
        return cell
    }
}

extension GourmetListDataSource: RxTableViewDataSourceType {
    
    func tableView(_ tableView: UITableView, observedEvent: Event<Element>) {
        Binder(self) { dataSource, element in
            dataSource._itemModels = element
            print("tableView item count", dataSource._itemModels.count)
            tableView.reloadData()
        }
        .on(observedEvent)
    }
}
