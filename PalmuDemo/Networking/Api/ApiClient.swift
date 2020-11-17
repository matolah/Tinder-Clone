//
//  ApiClient.swift
//  PalmuDemo
//
//  Created by mateus henrique lino santos on 19/10/20.
//  Copyright © 2020 Mateus Santos. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

enum ApiError: Error {
    case unexpected
}

extension ApiError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unexpected:
            return NSLocalizedString("Something unexpected happened.", comment: "Unexpected Error")
        }
    }
}

protocol ApiClient {
    func request<T: Codable>(_ urlConvertible: URLRequestConvertible) -> Observable<T>
}

extension ApiClient {
    /// - Returns: a generic type observable.
    func request<T: Codable>(_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        return Observable<T>.create { observer in
            AF.request(urlConvertible).responseDecodable { (response: DataResponse<T, AFError>) in
                switch response.result {
                case .success(let value):
                    print("Result obtained from the request \(value)")
                    observer.onNext(value)
                case .failure(let error):
                    print("Error in the request \(error)")
                    observer.onError(error)
                    return
                }
                
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
