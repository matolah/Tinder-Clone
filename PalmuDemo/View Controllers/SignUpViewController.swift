//
//  SignUpViewController.swift
//  PalmuDemo
//
//  Created by mateus henrique lino santos on 21/10/20.
//  Copyright © 2020 Mateus Santos. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var emailTextField: AuthTextField!
    @IBOutlet weak var passwordTextField: AuthTextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    //MARK: - Properties
    let disposeBag: DisposeBag = DisposeBag()
    let viewModel: SignUpViewModel = SignUpViewModel()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showNavigationBar()
    }
}

extension SignUpViewController: ReactiveViewControllerProtocol {
    func setupBindings() {
        /// View Model Inputs
        emailTextField.rx.text
            .orEmpty
            .bind(to: viewModel.input.email)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .orEmpty
            .bind(to: viewModel.input.password)
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .bind(to: viewModel.input.signUpTapped)
            .disposed(by: disposeBag)
        
        /// View Model Outputs
        viewModel.output.alertMessage
            .drive(onNext: { [weak self] message in
                self?.presentAlert(withMessage: message)
            }).disposed(by: disposeBag)
        
        viewModel.output.signedUp
            .drive(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
}
