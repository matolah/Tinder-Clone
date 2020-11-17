//
//  FireAuth+Extension.swift
//  PalmuDemo
//
//  Created by mateus henrique lino santos on 18/10/20.
//  Copyright © 2020 Mateus Santos. All rights reserved.
//

import Foundation
import FirebaseAuth
import RxSwift

extension Auth {
    /// - Returns: an observable from the signIn method.
    func signInAsObservable(with email: String, password: String) -> Observable<AuthDataResult> {
        return Observable.create { observer in
            self.signIn(withEmail: email, password: password) { result, error in
                guard let result = result else {
                    observer.onError(error ?? ApiError.unexpected)
                    return
                }
                
                observer.onNext(result)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    /// - Returns: an observable from the signUp method.
    func signUpAsObservable(with email: String, password: String) -> Observable<AuthDataResult> {
        return Observable.create { observer in
            self.createUser(withEmail: email, password: password) { result, error in
                guard let result = result else {
                    observer.onError(error ?? ApiError.unexpected)
                    return
                }
                
                observer.onNext(result)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
