//
//  UserViewModel.swift
//  PalmuDemo
//
//  Created by mateus henrique lino santos on 18/10/20.
//  Copyright © 2020 Mateus Santos. All rights reserved.
//

import Foundation

class CredentialsViewModel {
    //MARK: - Properties
    let email: String
    let password: String
    
    //MARK: - Init
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
