//
//  UIImage+Extension.swift
//  PalmuDemo
//
//  Created by mateus henrique lino santos on 20/10/20.
//  Copyright © 2020 Mateus Santos. All rights reserved.
//

import UIKit

extension UIImage {
    static func fromURL(_ url: URL) -> UIImage? {
        var image: UIImage?
        
        if let data = try? Data(contentsOf: url) {
            image = UIImage(data: data)
        }
        
        return image
    }
}
