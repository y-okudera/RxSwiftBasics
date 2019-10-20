//
//  WeatherListDataSource.swift
//  Training2
//
//  Created by Yuki Okudera on 2019/10/21.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class WeatherListDataSource: NSObject {
    typealias Element = [Forecasts]
    var _itemModels: [Forecasts] = []
}

// MARK: UITableViewDataSource
extension WeatherListDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _itemModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let element = _itemModels[indexPath.row]
        cell.textLabel?.text = element.date
        cell.detailTextLabel?.text = element.telop
        return cell
    }
}

extension WeatherListDataSource: RxTableViewDataSourceType {
    
    func tableView(_ tableView: UITableView, observedEvent: Event<Element>) {
        Binder(self) { dataSource, element in
            dataSource._itemModels = element
            tableView.reloadData()
        }
        .on(observedEvent)
    }
}
