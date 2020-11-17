//
//  ViewModel.swift
//  PalmuDemo
//
//  Created by mateus henrique lino santos on 20/10/20.
//  Copyright © 2020 Mateus Santos. All rights reserved.
//

import Foundation
import RxCocoa

protocol ViewModelProtocol {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}
