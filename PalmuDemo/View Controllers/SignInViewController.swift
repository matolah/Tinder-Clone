//
//  SignInViewController.swift
//  PalmuDemo
//
//  Created by mateus henrique lino santos on 18/10/20.
//  Copyright © 2020 Mateus Santos. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignInViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var emailTextField: AuthTextField!
    @IBOutlet weak var passwordTextField: AuthTextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    //MARK: - Properties
    let viewModel: SignInViewModel = SignInViewModel()
    let disposeBag = DisposeBag()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showNavigationBar()
    }
    
    //MARK: - Private Methods
    private func presentMatchingStoryboard() {
        presentStoryboard("Matching", withIdentifier: "Matching")
    }
}

//MARK: - RxViewController
extension SignInViewController: ReactiveViewControllerProtocol {
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
        
        signInButton.rx.tap
            .bind(to: viewModel.input.signInTapped)
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.performSegue(withIdentifier: "goToSignUp", sender: self)
            })
            .disposed(by: disposeBag)
        
        /// View Model Outputs
        viewModel.output.alertMessage
            .drive(onNext: { [weak self] message in
                self?.presentAlert(withMessage: message)
            }).disposed(by: disposeBag)
        
        viewModel.output.signedIn
            .drive(onNext: { [weak self] _ in
                self?.presentMatchingStoryboard()
            }).disposed(by: disposeBag)
    }
}
