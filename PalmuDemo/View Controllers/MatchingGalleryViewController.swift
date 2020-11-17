//
//  MatchingGalleryViewController.swift
//  PalmuDemo
//
//  Created by mateus henrique lino santos on 21/10/20.
//  Copyright © 2020 Mateus Santos. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MatchingGalleryViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var swipeView: SwipeView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    //MARK: - Properties
    let viewModel: MatchingGalleryViewModel = MatchingGalleryViewModel()
    let disposeBag = DisposeBag()

    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showNavigationBar()
        
        setupBindings()
        
        /// Initial images
        viewModel.input.reload.onNext(())
    }
}

//MARK: - RxViewController
extension MatchingGalleryViewController: ReactiveViewControllerProtocol {
    func setupBindings() {
        /// Swipe View Delegate
        swipeView.rx.endOfCardsReached
            .subscribe(onNext: { [weak self] _ in self?.viewModel.input.reload.onNext(()) })
            .disposed(by: disposeBag)
        
        /// Swipe View Actions
        skipButton.rx.tap
            .subscribe(onNext: { [weak self] _ in self?.swipeView.makeLeftSwipeAction() })
            .disposed(by: disposeBag)
        
        likeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in self?.swipeView.makeRightSwipeAction() })
            .disposed(by: disposeBag)
        
        /// View Model Inputs
        likeButton.rx.tap
            .bind(to: viewModel.input.likeTapped)
            .disposed(by: disposeBag)
        
        /// View Model Outputs
        viewModel.output.matchings
            .drive(onNext: { [weak self] matchings in
                self?.swipeView.showPersonCards(with: matchings)
            })
            .disposed(by: disposeBag)
    }
}
