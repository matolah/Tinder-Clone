//
//  SignInViewModel.swift
//  PalmuDemo
//
//  Created by mateus henrique lino santos on 18/10/20.
//  Copyright © 2020 Mateus Santos. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class SignInViewModel: ViewModelProtocol {
    //MARK: - Inputs
    let input: Input
    
    struct Input {
        let email: PublishRelay<String>
        let password: PublishRelay<String>
        let signInTapped: PublishRelay<Void>
    }
    
    //MARK: - Outputs
    let output: Output
    
    struct Output {
        let alertMessage: Driver<String>
        let signedIn: Driver<Void>
    }
    
    //MARK: - Input -> Output
    init(authService: AuthService = AuthService()) {
        /// Input initalization
        let emailSubject = PublishRelay<String>()
        let passwordSubject = PublishRelay<String>()
        let signInTappedSubject = PublishRelay<Void>()
        
        let alertMessageSubject = PublishSubject<String>()
        let alertMessage = alertMessageSubject.asDriver(onErrorRecover: { fatalError($0.localizedDescription) })
        
        let emailAndPassword = Observable.combineLatest(emailSubject, passwordSubject)
        
        let signedIn = signInTappedSubject.withLatestFrom(emailAndPassword)
            .flatMapLatest({ email, password in
                return authService.signIn(withEmail: email, password: password)
                    .catchError({ error in
                        alertMessageSubject.onNext(error.localizedDescription)
                        return Observable.never()
                    })
            })
            .map { _ in () }
            .asDriver(onErrorRecover: { fatalError($0.localizedDescription) })
        
        self.input = Input(email: emailSubject, password: passwordSubject, signInTapped: signInTappedSubject)
        self.output = Output(alertMessage: alertMessage, signedIn: signedIn)
    }
}
