//
//  AuthService.swift
//  PalmuDemo
//
//  Created by mateus henrique lino santos on 18/10/20.
//  Copyright © 2020 Mateus Santos. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseAuth

final class AuthService {
    //MARK: - Properties
    private let auth = Auth.auth()
    
    //MARK: - Public Methods
    /// Signs the user in
    func signIn(withEmail email: String, password: String) -> Observable<AuthDataResult> {
        return auth.signInAsObservable(with: email, password: password)
    }
    
    /// Signs the user up
    func signUp(withEmail email: String, password: String) -> Observable<AuthDataResult> {
        return auth.signUpAsObservable(with: email, password: password)
    }
}
