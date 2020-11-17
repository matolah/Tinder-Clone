//
//  Photo.swift
//  PalmuDemo
//
//  Created by mateus henrique lino santos on 19/10/20.
//  Copyright © 2020 Mateus Santos. All rights reserved.
//

import Foundation

//MARK: - Photo
struct Photo: Codable {
    let location: Location
    let urls: Urls
    let user: User
}

//MARK: - Location
struct Location: Codable {
    let country: String?
}

//MARK: - Urls
struct Urls: Codable {
    let regular: String
}

//MARK: - User
struct User: Codable {
    let name: String
}
