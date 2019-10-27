//
//  UIViewController+Alert.swift
//  Training3
//
//  Created by Yuki Okudera on 2019/10/27.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showError(message: String?) {
        let alertController = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
        alertController.addAction(.init(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
