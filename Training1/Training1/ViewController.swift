//
//  ViewController.swift
//  Training1
//
//  Created by Yuki Okudera on 2019/10/21.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class ViewController: UIViewController {

    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var resetCountButton: UIButton!
    @IBOutlet private weak var countUpButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
    }
}

extension ViewController {
    
    private func setupRx() {
        
        // UITextFieldに入力したテキストをUILabelに反映させる
        self.textField.rx.text.orEmpty.subscribe { [weak self] text in
            guard let weakSelf = self else {
                return
            }
            weakSelf.label.text = text.element
        }
        .disposed(by: self.disposeBag)
        
        // UIButtonのタップイベント
        self.countUpButton.rx.tap.subscribe { [weak self] _ in
            guard let weakSelf = self else {
                return
            }
            weakSelf.count += 1
            weakSelf.countUpButton.setTitle("Count is \(weakSelf.count)!!", for: .normal)
        }
        .disposed(by: self.disposeBag)
        
        self.resetCountButton.rx.tap.subscribe { [weak self] _ in
            guard let weakSelf = self else {
                return
            }
            weakSelf.count = 0
            weakSelf.countUpButton.setTitle("Count up!", for: .normal)
        }
        .disposed(by: self.disposeBag)
    }
}
