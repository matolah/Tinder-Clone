//
//  MatchingViewModel.swift
//  PalmuDemo
//
//  Created by mateus henrique lino santos on 19/10/20.
//  Copyright © 2020 Mateus Santos. All rights reserved.
//

import Foundation

class PersonCardViewModel {
    let imageURL: String
    let name: String
    let age: Int
    
    init(imageURL: String, name: String, age: Int) {
        self.imageURL = imageURL
        self.name = name
        self.age = age
    }
}
