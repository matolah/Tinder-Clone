//
//  BaseViewController.swift
//  PalmuDemo
//
//  Created by mateus henrique lino santos on 19/10/20.
//  Copyright © 2020 Mateus Santos. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol ReactiveViewControllerProtocol: UIViewController {
    var disposeBag: DisposeBag { get }
    
    func setupBindings()
}
