//
//  UIColor+Extension.swift
//  PalmuDemo
//
//  Created by mateus henrique lino santos on 18/10/20.
//  Copyright © 2020 Mateus Santos. All rights reserved.
//

import UIKit

extension UIColor {
    enum AppColor: String {
        //MARK: - Cases
        case primary = "PrimaryColor"
        case light = "LightColor"
        
        //MARK: - Properties
        var uiColor: UIColor? {
            return UIColor.init(named: self.rawValue)
        }
    }
}
