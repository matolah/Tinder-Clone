//
//  AuthTextField.swift
//  PalmuDemo
//
//  Created by mateus henrique lino santos on 18/10/20.
//  Copyright © 2020 Mateus Santos. All rights reserved.
//

import UIKit

@IBDesignable
class AuthTextField: UITextField {
    //MARK: - IBInspectables
    @IBInspectable var icon: UIImage? { didSet { updateView() }}
    @IBInspectable var iconColor: UIColor = .darkGray { didSet { updateView() }}
    
    //MARK: - Properties
    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    let iconPadding: CGFloat = 15
    
    //MARK: - Lifecycle
    override func draw(_ rect: CGRect) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: frame.height - 1, width: frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        borderStyle = UITextField.BorderStyle.none
        layer.addSublayer(bottomLine)
        clipsToBounds = true
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return super.placeholderRect(forBounds: bounds)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.editingRect(forBounds: bounds)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += iconPadding
        
        return textRect
    }
    
    //MARK: - Public Methods
    func updateView() {
        rightViewMode = UITextField.ViewMode.never
        rightView = nil
        
        leftViewMode = UITextField.ViewMode.always
        leftView = nil

        if let image = icon {
            let button = UIButton(type: .custom)

            let tintedImage = image.withRenderingMode(.alwaysTemplate)
            button.setImage(tintedImage, for: .normal)
            button.tintColor = iconColor

            button.setTitleColor(UIColor.clear, for: .normal)
            button.isUserInteractionEnabled = true

            button.frame = CGRect(x: 10, y: 5, width: 20, height: 20)
            
            let buttonContainer: UIView = UIView(frame:
                           CGRect(x: 20, y: 0, width: 40, height: 30))
            buttonContainer.addSubview(button)
                
            leftView = buttonContainer
        }
    }
}
