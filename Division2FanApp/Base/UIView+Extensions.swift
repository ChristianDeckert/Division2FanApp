//
//  UIView+Extensions.swift
//  Division2FanApp
//
//  Created by Christian on 16.03.19.
//  Copyright © 2019 Christian Deckert. All rights reserved.
//

import UIKit

public extension UIView {

  enum Animations {
    case none
    case fade(duration: TimeInterval)
    case pushFromBottom(duration: TimeInterval)
    case springAnimation(duration: TimeInterval)
    case scale(duration: TimeInterval)

    public var isAnimated: Bool {
      switch self {
      case .none: return false
      default: return true
      }
    }

    public var isFade: Bool {
      switch self {
      case .fade: return true
      default: return false
      }
    }

    public var isPushFromBottom: Bool {
      switch self {
      case .pushFromBottom: return true
      default: return false
      }
    }

    public var isSpringAnimation: Bool {
      switch self {
      case .springAnimation: return true
      default: return false
      }
    }

    public var isScaleAnimation: Bool {
      switch self {
      case .springAnimation: return true
      default: return false
      }
    }

    public static var preferredSpringAnimationDuration: TimeInterval = 0.5
    public static var preferredAnimationDuration: TimeInterval = 0.3
    public static var preferredDamping: CGFloat = 0.45
    public static var preferredMinimumScaleTransformation: CGAffineTransform = CGAffineTransform(scaleX: 0.01, y: 0.01)
  }

  func animate(in viewAnimation: Animations, fromCurrentState: Bool = true, completion: ((_ complete: Bool) -> Void)? = nil) {
    switch viewAnimation {
    case .none:
      if !fromCurrentState {
        alpha = 0
      }
      alpha = 1
      completion?(true)
    case .pushFromBottom(let duration):
      if !fromCurrentState {
        transform = CGAffineTransform(translationX: 0, y: bounds.height)
        alpha = 1
      }
      UIView.animate(withDuration: duration, animations: {
        self.transform = .identity
      }, completion: completion)

    case .fade(let duration):
      if !fromCurrentState {
        alpha = 0
      }
      UIView.animate(withDuration: duration, animations: {
        self.alpha = 1
      }, completion: completion)

    case .scale(let duration):
      if !fromCurrentState {
        transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        alpha = 1
      }
      UIView.animate(withDuration: duration, animations: {
        self.transform = .identity
        self.alpha = 1
      }, completion: completion)

    case .springAnimation(let duration):
      UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: Animations.preferredDamping, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
        self.transform = .identity
        self.alpha = 1
      }, completion: completion)

    }
  }

  func embed(in parentView: UIView, insets: UIEdgeInsets = .zero) {
    NSLayoutConstraint.embed(view: self, in: parentView, insets: insets)
  }
}
