//
//  UIViewController+Extension.swift
//  PalmuDemo
//
//  Created by mateus henrique lino santos on 19/10/20.
//  Copyright © 2020 Mateus Santos. All rights reserved.
//

import UIKit

extension UIViewController {
    func showNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func presentStoryboard(_ name: String, withIdentifier identifier: String) {
        let vc = UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: identifier) as UIViewController
        present(vc, animated: true, completion: nil)
    }
    
    func presentAlert(withMessage message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alertController, animated: true)
    }
}
