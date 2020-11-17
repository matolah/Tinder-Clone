//
//  SwipeView.swift
//  PalmuDemo
//
//  Created by mateus henrique lino santos on 21/10/20.
//  Copyright © 2020 Mateus Santos. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

let inset: CGFloat = 10
let bufferSize: Int = 3

/// Reactive delegate protocol
@objc protocol SwipeViewDelegate: class {
    @objc optional func cardGoesLeft(_ model: Any)
    @objc optional func cardGoesRight(_ model: Any)
    @objc optional func undoCardsDone(_ model: Any)
    @objc optional func endOfCardsReached()
}

class SwipeView: UIView {
    //MARK: - Properties
    let disposeBag = DisposeBag()
    
    var separatorDistance: CGFloat = 8
    
    var index = 0
    
    fileprivate var allCards = [PersonCardViewModel]()
    fileprivate var loadedCards = [PersonCard]()
    fileprivate var currentCard : PersonCard!
    
    weak var delegate: SwipeViewDelegate?
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Setup
    private func setupBindings(from card: PersonCard) {
        card.rx.cardGoesRight
            .subscribe(onNext: { [unowned self] _ in self.removeCardAndAddNew() })
            .disposed(by: disposeBag)
        
        card.rx.cardGoesLeft
            .subscribe(onNext: { [unowned self] _ in self.removeCardAndAddNew() })
            .disposed(by: disposeBag)
    }
    
    
    //MARK: - Public Methods
    func showPersonCards(with elements: [PersonCardViewModel]) {
        if elements.isEmpty { return }
        
        allCards.append(contentsOf: elements)
        
        for (i, element) in elements.enumerated() {
            if loadedCards.count < bufferSize {
                let cardView = self.createPersonCard(index: i, element: element)
                
                if loadedCards.isEmpty {
                    self.addSubview(cardView)
                } else {
                    self.insertSubview(cardView, belowSubview: loadedCards.last!)
                }
                
                loadedCards.append(cardView)
            }
        }
        
        animateCardAfterSwiping()
    }
    
    func makeLeftSwipeAction() {
        if let card = loadedCards.first {
            card.leftClickAction()
        }
    }
    
    func makeRightSwipeAction() {
        if let card = loadedCards.first {
            card.rightClickAction()
        }
    }
    
    //MARK: - Private Methods
    fileprivate func createPersonCard(index: Int, element: PersonCardViewModel) -> PersonCard {
        let card = PersonCard(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        setupBindings(from: card)
        
        if let image = UIImage.fromURL(URL(string: element.imageURL)!) {
            card.display(photo: image)
        }
        
        card.display(name: element.name)
        card.display(age: element.age)
        
        return card
    }
    
    fileprivate func animateCardAfterSwiping() {
        if loadedCards.isEmpty {
            self.delegate?.endOfCardsReached?()
            
            return
        }
        
        for (i,card) in loadedCards.enumerated() {
            UIView.animate(withDuration: 0.5, animations: {
                card.isUserInteractionEnabled = i == 0 ? true : false
                var frame = card.frame
                frame.origin.y = inset + (CGFloat(i) * self.separatorDistance)
                card.frame = frame
            })
        }
    }
    
    fileprivate func removeCardAndAddNew() {
        index += 1
        
        let card = loadedCards.first!
        card.index = index
        
        Timer.scheduledTimer(timeInterval: 1.01, target: self, selector: #selector(enableUndoButton), userInfo: card, repeats: false)
        loadedCards.remove(at: 0)
        
        if (index + loadedCards.count) < allCards.count {
            let PersonCard = createPersonCard(index: index + loadedCards.count, element: allCards[index + loadedCards.count])
            self.insertSubview(PersonCard, belowSubview: loadedCards.last!)
            loadedCards.append(PersonCard)
        }
        
        animateCardAfterSwiping()
    }
    
    @objc private func enableUndoButton(timer: Timer) {
        let card = timer.userInfo as! PersonCard
        
        if card.index == index{
            currentCard = card
        }
    }
}

//MARK: - Delegate Proxy
class SwipeViewDelegateProxy:
    DelegateProxy<SwipeView, SwipeViewDelegate>,
    DelegateProxyType,
    SwipeViewDelegate {

    init(parentObject: SwipeView) {
        super.init(parentObject: parentObject, delegateProxy: SwipeViewDelegateProxy.self)
    }

    public static func registerKnownImplementations() {
        self.register { SwipeViewDelegateProxy(parentObject: $0) }
    }
}

//MARK: - Delegate Type
extension SwipeView: HasDelegate {
    typealias Delegate = SwipeViewDelegate
}

//MARK: - Reactive Delegate Methods
extension Reactive where Base: SwipeView {
    var delegate: SwipeViewDelegateProxy {
        return SwipeViewDelegateProxy.proxy(for: base)
    }
    
    var cardGoesRight: Observable<Void> {
        return delegate.methodInvoked(#selector(SwipeViewDelegate.cardGoesRight(_:)))
            .map { _ in () }
    }
    
    var cardGoesLeft: Observable<Void> {
        return delegate.methodInvoked(#selector(SwipeViewDelegate.cardGoesLeft(_:)))
            .map { _ in () }
    }
    
    var endOfCardsReached: Observable<Void> {
        return delegate.methodInvoked(#selector(SwipeViewDelegate.endOfCardsReached))
            .map { _ in () }
    }
}
