//
//  MatchingGalleryViewModel.swift
//  PalmuDemo
//
//  Created by mateus henrique lino santos on 19/10/20.
//  Copyright © 2020 Mateus Santos. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class MatchingGalleryViewModel: ViewModelProtocol {
    //MARK: - Inputs
    let input: Input
    
    struct Input {
        let likeTapped: PublishRelay<Void>
        let reload: PublishSubject<Void>
    }
    
    //MARK: - Outputs
    let output: Output
    
    struct Output {
        let matchings: Driver<[PersonCardViewModel]>
    }
    
    //MARK: - Input -> Output
    init(matchingService: MatchingService = MatchingService()) {
        /// Input initalization
        let likeTappedSubject = PublishRelay<Void>()
        let reloadSubject = PublishSubject<Void>()
        
        let matchings = reloadSubject
            .flatMapLatest({
                return matchingService.getRandomImages(count: K.cardsCount)
                    .catchError { _ in Observable.never() }
            })
            .map({ photos in
                photos.map { PersonCardViewModel(imageURL: $0.urls.regular,
                                               name: $0.user.name,
                                               age: Int.random(in: 21..<35))
                }
            })
            .asDriver(onErrorRecover: { fatalError($0.localizedDescription) })
        
        input = Input(likeTapped: likeTappedSubject, reload: reloadSubject)
        output = Output(matchings: matchings)
    }
}
