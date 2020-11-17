//
//  Firestore+Extension.swift
//  PalmuDemo
//
//  Created by mateus henrique lino santos on 18/10/20.
//  Copyright © 2020 Mateus Santos. All rights reserved.
//

import Foundation
import FirebaseFirestore
import RxSwift

extension CollectionReference {
    /// - Returns: an observable from the getDocuments method.
    func documentsAsObservable() -> Observable<QuerySnapshot> {
        return Observable.create { observer in
            self.getDocuments { snapshot, error in
                guard let snapshot = snapshot else {
                    observer.onError(error ?? ApiError.unexpected)
                    return
                }
                
                observer.onNext(snapshot)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
