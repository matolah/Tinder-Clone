//
//  ApiRouter.swift
//  PalmuDemo
//
//  Created by mateus henrique lino santos on 19/10/20.
//  Copyright © 2020 Mateus Santos. All rights reserved.
//

import Foundation
import Alamofire

enum ApiRouter: URLRequestConvertible {
    /// Endpoints.
    case getRandomImages(count: Int)
    
    //MARK: - URL
    private var baseURL: String {
        switch self {
        case .getRandomImages:
            return K.Unsplash.baseURL
        }
    }
    
    //MARK: - Path
    private var path: String {
        switch self {
        case .getRandomImages(let count):
            return "/photos/random?count=\(count)&query=man,woman"
        }
    }
    
    //MARK: - HTTP Method
    private var method: HTTPMethod {
        switch self {
        case .getRandomImages:
            return .get
        }
    }
    
    //MARK: - Custom Headers
    private var customHeaders: [String:String] {
        var headers = [HttpHeaderField.contentType.rawValue: ContentType.json.rawValue]
        
        switch self {
        case .getRandomImages:
            headers[HttpHeaderField.authorization.rawValue] = K.Unsplash.accessKey
        }
        
        return headers
    }
    
    //MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: baseURL + path)!
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = method.rawValue
        
        /// Common Headers
        customHeaders.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }
        
        return urlRequest
    }
}
