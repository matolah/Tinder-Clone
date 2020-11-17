//
//  MatchingGalleryViewController.swift
//  PalmuDemo
//
//  Created by mateus henrique lino santos on 19/10/20.
//  Copyright © 2020 Mateus Santos. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MatchingViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    //MARK: - Properties
    let disposeBag = DisposeBag()
    
    private lazy var matchingGalleryViewController: MatchingGalleryViewController = {
        let storyboard = UIStoryboard(name: "Matching", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "MatchingGallery") as! MatchingGalleryViewController
        
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var likedViewController: LikedViewController = {
        let storyboard = UIStoryboard(name: "Matching", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "Liked") as! LikedViewController
        
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
    }
    
    //MARK: - Segment Transition Methods
    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        
        containerView.addSubview(viewController.view)
        
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)

        viewController.view.removeFromSuperview()
        
        viewController.removeFromParent()
    }
}

//MARK: - RxViewController
extension MatchingViewController: ReactiveViewControllerProtocol {
    func setupBindings() {
        /// Segmented Control Changes
        segmentedControl.rx.selectedSegmentIndex
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                
                if value == 0 {
                    self.remove(asChildViewController: self.likedViewController)
                    self.add(asChildViewController: self.matchingGalleryViewController)
                } else {
                    self.remove(asChildViewController: self.matchingGalleryViewController)
                    self.add(asChildViewController: self.likedViewController)
                }
            })
            .disposed(by: disposeBag)
    }
}
