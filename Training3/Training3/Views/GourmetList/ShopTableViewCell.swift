//
//  ShopTableViewCell.swift
//  Training3
//
//  Created by Yuki Okudera on 2019/10/27.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Nuke
import RxNuke
import RxSwift
import UIKit

final class ShopTableViewCell: UITableViewCell {

    @IBOutlet private weak var shopImageView: UIImageView!
    @IBOutlet private weak var shopNameLabel: UILabel!
    private let disposeBag = DisposeBag()
    
    var shop: Shop? {
        didSet {
            set(shop: shop)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        shopImageView.image = nil
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
