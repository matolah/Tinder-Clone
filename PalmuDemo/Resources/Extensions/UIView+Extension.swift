//
//  UIView+Extension.swift
//  PalmuDemo
//
//  Created by mateus henrique lino santos on 20/10/20.
//  Copyright © 2020 Mateus Santos. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
