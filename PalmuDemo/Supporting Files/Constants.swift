//
//  Constants.swift
//  PalmuDemo
//
//  Created by mateus henrique lino santos on 19/10/20.
//  Copyright © 2020 Mateus Santos. All rights reserved.
//

import Foundation

struct K {
    static let cardsCount: Int = 10
    
    struct Unsplash {
        static let baseURL = "https://api.unsplash.com"
        static let accessKey = "Client-ID yVM3rVvkjNOcb994gMu1KhwEW6ixC2CtLJqB7A-hZEU"
    }
}

enum HttpHeaderField: String {
    case contentType = "Content-Type"
    case authorization = "Authorization"
}

enum ContentType: String {
    case json = "application/json"
}
