//
//  PersonCard.swift
//  PalmuDemo
//
//  Created by mateus henrique lino santos on 19/10/20.
//  Copyright © 2020 Mateus Santos. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

let thresholdMargin = (UIScreen.main.bounds.size.width / 2) * 0.75
let stength: CGFloat = 4
let range: CGFloat = 0.9

/// Reactive delegate protocol
@objc protocol PersonCardDelegate: NSObjectProtocol {
    @objc optional func didSelectCard(_ card: PersonCard)
    @objc optional func cardGoesRight(_ card: PersonCard)
    @objc optional func cardGoesLeft(_ card: PersonCard)
    @objc optional func currentCardStatus(_ card: PersonCard, distance: CGFloat)
    @objc optional func fallbackCard(_ card: PersonCard)
}

class PersonCard: UIView {
    //MARK: - IBOutlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var overlayImageView: UIImageView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    //MARK: - Properties
    var index: Int!
    var xCenter: CGFloat = 0.0
    var yCenter: CGFloat = 0.0
    var originalPoint = CGPoint.zero
    
    weak var delegate: PersonCardDelegate?
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Setup
    private func setupView() {
        Bundle.main.loadNibNamed("PersonCard", owner: self, options: nil)
        
        addSubview(contentView)
        contentView.frame = self.bounds
        
        containerView.layer.cornerRadius = bounds.width/20
        containerView.layer.shadowRadius = 3
        containerView.layer.shadowOpacity = 0.4
        containerView.layer.shadowOffset = CGSize(width: 0.5, height: 3)
        containerView.layer.shadowColor = UIColor.darkGray.cgColor
        containerView.clipsToBounds = true
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.beingDragged))
        panGestureRecognizer.delegate = self
        
        addGestureRecognizer(panGestureRecognizer)
    }
    
    //MARK: - Public Methods
    func display(photo newPhoto: UIImage) {
        photo.image = newPhoto
    }
    
    func display(name newName: String) {
        nameLabel.text = newName
    }
    
    func display(age newAge: Int) {
        ageLabel.text = "\(newAge)"
    }
    
    func cardGoesRight() {
        let finishPoint = CGPoint(x: frame.size.width * 2, y: 2 * yCenter + originalPoint.y)
        
        center(to: finishPoint)
        
        delegate?.cardGoesRight?(self)
    }
    
    func cardGoesLeft() {
        let finishPoint = CGPoint(x: -frame.size.width * 2, y: 2 * yCenter + originalPoint.y)
        
        center(to: finishPoint)
        
        delegate?.cardGoesLeft?(self)
    }
    
    func rightClickAction() {
        setInitialLayoutStatus(isLeft: false)
        
        let finishPoint = CGPoint(x: center.x + frame.size.width * 2, y: center.y)
        
        animateCard(to: finishPoint, withAngle: 1)
        
        delegate?.cardGoesRight?(self)
    }
    
    func leftClickAction() {
        setInitialLayoutStatus(isLeft: true)
        
        let finishPoint = CGPoint(x: center.x - frame.size.width * 2, y: center.y)
        
        animateCard(to: finishPoint, withAngle: -1)
        
        delegate?.cardGoesLeft?(self)
    }
    
    func rollBackCard() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    func shakeAnimationCard(completion: @escaping (Bool) -> ()) {
        statusImageView.image = makeImage(name: "ic_skip")
        overlayImageView.image = makeImage(name: "overlay_skip")
        
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            let finishPoint = CGPoint(x: self.center.x - (self.frame.size.width / 2), y: self.center.y)
            
            self.animateCard(to: finishPoint, angle: -0.2, alpha: 1.0)
        }, completion: {(_) -> Void in
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                self.animateCard(to: self.originalPoint)
            }, completion: {(_ complete: Bool) -> Void in
                self.statusImageView.image = self.makeImage(name: "ic_like")
                self.overlayImageView.image =  self.makeImage(name: "overlay_like")
                
                UIView.animate(withDuration: 0.5, animations: {() -> Void in
                    let finishPoint = CGPoint(x: self.center.x + (self.frame.size.width / 2) ,y: self.center.y)
                    
                    self.animateCard(to: finishPoint, angle: 0.2, alpha: 1)
                }, completion: {(_ complete: Bool) -> Void in
                    UIView.animate(withDuration: 0.5, animations: {() -> Void in
                        self.animateCard(to: self.originalPoint)
                    }, completion: {(_ complete: Bool) -> Void in
                        completion(true)
                    })
                })
            })
        })
    }
    
    //MARK: - Private Methods
    fileprivate func setInitialLayoutStatus(isLeft: Bool) {
        statusImageView.alpha = 0.5
        overlayImageView.alpha = 0.5
        
        statusImageView.image = makeImage(name: isLeft ?  "ic_skip" : "ic_like")
        overlayImageView.image = makeImage(name: isLeft ?  "overlay_skip" : "overlay_like")
    }
    
    fileprivate func makeImage(name: String) -> UIImage? {
        let image = UIImage(named: name, in: Bundle(for: type(of: self)), compatibleWith: nil)
        return image
    }
    
    fileprivate func animateCard(to center: CGPoint, angle: CGFloat = 0, alpha: CGFloat = 0) {
        self.center = center
        self.transform = CGAffineTransform(rotationAngle: angle)
        
        statusImageView.alpha = alpha
        overlayImageView.alpha = alpha
    }
    
    fileprivate func center(to finishPoint: CGPoint) {
        UIView.animate(withDuration: 0.5, animations: {
            self.center = finishPoint
        }, completion: {(_) in
            self.removeFromSuperview()
        })
    }
    
    fileprivate func animateCard(to finishPoint: CGPoint, withAngle angle: CGFloat) {
        UIView.animate(withDuration: 1.0, animations: {() -> Void in
            self.animateCard(to: finishPoint, angle: angle, alpha: 1.0)
        }, completion: {(_ complete: Bool) -> Void in
            self.removeFromSuperview()
        })
    }
}

//MARK: - UIGestureRecognizer Delegate Methods
extension PersonCard: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc fileprivate func beingDragged(_ gestureRecognizer: UIPanGestureRecognizer) {
        xCenter = gestureRecognizer.translation(in: self).x
        yCenter = gestureRecognizer.translation(in: self).y
        
        switch gestureRecognizer.state {
        case .began:
            originalPoint = self.center;
            
            self.delegate?.didSelectCard?(self)
            
            break;
        case .changed:
            let rotationStrength = min(xCenter / UIScreen.main.bounds.size.width, 1)
            let rotationAngel = .pi/8 * rotationStrength
            let scale = max(1 - abs(rotationStrength) / stength, range)
            
            center = CGPoint(x: originalPoint.x + xCenter, y: originalPoint.y + yCenter)
            
            let transforms = CGAffineTransform(rotationAngle: rotationAngel)
            let scaleTransform: CGAffineTransform = transforms.scaledBy(x: scale, y: scale)
            
            self.transform = scaleTransform
            updateOverlay(xCenter)
            
            break;
        case .ended:
            afterSwipeAction()
            
            break;
        case .possible: break
        case .cancelled: break
        case .failed: break
        @unknown default:
            fatalError()
        }
    }
    
    fileprivate func afterSwipeAction() {
        if xCenter > thresholdMargin {
            cardGoesRight()
        } else if xCenter < -thresholdMargin {
            cardGoesLeft()
        } else {
            self.delegate?.fallbackCard?(self)
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: [], animations: {
                self.center = self.originalPoint
                self.transform = CGAffineTransform(rotationAngle: 0)
                self.statusImageView.alpha = 0
                self.overlayImageView.alpha = 0
            })
        }
    }
    
    fileprivate func updateOverlay(_ distance: CGFloat) {
        statusImageView.image = makeImage(name:  distance > 0 ? "ic_like" : "ic_skip")
        overlayImageView.image = makeImage(name:  distance > 0 ? "overlay_like" : "overlay_skip")
        statusImageView.alpha = min(abs(distance) / 100, 0.8)
        overlayImageView.alpha = min(abs(distance) / 100, 0.8)
        delegate?.currentCardStatus?(self, distance: distance)
    }
}

//MARK: - Delegate Proxy
class PersonCardDelegateProxy:
    DelegateProxy<PersonCard, PersonCardDelegate>,
    DelegateProxyType,
    PersonCardDelegate {

    init(parentObject: PersonCard) {
        super.init(parentObject: parentObject, delegateProxy: PersonCardDelegateProxy.self)
    }

    public static func registerKnownImplementations() {
        self.register { PersonCardDelegateProxy(parentObject: $0) }
    }
}

//MARK: - Delegate Type
extension PersonCard: HasDelegate {
    typealias Delegate = PersonCardDelegate
}

//MARK: - Reactive Delegate Methods
extension Reactive where Base: PersonCard {
    var delegate: PersonCardDelegateProxy {
        return PersonCardDelegateProxy.proxy(for: base)
    }

    var didSelectCard: Observable<Void> {
        return delegate.methodInvoked(#selector(PersonCardDelegate.didSelectCard(_:)))
            .map { _ in () }
    }
    
    var cardGoesRight: Observable<Void> {
        return delegate.methodInvoked(#selector(PersonCardDelegate.cardGoesRight(_:)))
            .map { _ in () }
    }
    
    var cardGoesLeft: Observable<Void> {
        return delegate.methodInvoked(#selector(PersonCardDelegate.cardGoesLeft(_:)))
            .map { _ in () }
    }
}
