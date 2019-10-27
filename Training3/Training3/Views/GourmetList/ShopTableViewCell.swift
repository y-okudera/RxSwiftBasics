//
//  ShopTableViewCell.swift
//  Training3
//
//  Created by Yuki Okudera on 2019/10/27.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Nuke
import RxSwift
import RxNuke
import UIKit

final class ShopTableViewCell: UITableViewCell {

    @IBOutlet private(set) weak var shopImageView: UIImageView!
    @IBOutlet private(set) weak var shopNameLabel: UILabel!
    private var disposeBag = DisposeBag()
    
    var shop: Shop? {
        didSet {
            set(shop: shop)
        }
    }
}

extension ShopTableViewCell {
    
    private func set(shop: Shop?) {
        guard let shop = self.shop else {
            return
        }
        self.shopNameLabel.text = shop.name
        
        guard let logoImageUrl = URL(string: shop.logoImage) else {
            return
        }
        ImagePipeline.shared.rx.loadImage(with: ImageRequest(url: logoImageUrl))
            .subscribe(onSuccess: { [weak self] in
                self?.shopImageView.image = $0.image
            })
            .disposed(by: disposeBag)
    }
}
