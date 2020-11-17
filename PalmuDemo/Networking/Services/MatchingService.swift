//
//  MatchingService.swift
//  PalmuDemo
//
//  Created by mateus henrique lino santos on 19/10/20.
//  Copyright © 2020 Mateus Santos. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import FirebaseFirestore

final class MatchingService: ApiClient {
    //MARK: - Public Methods
    func getRandomImages(count: Int) -> Observable<[Photo]> {
        return request(ApiRouter.getRandomImages(count: count))
    }
}
