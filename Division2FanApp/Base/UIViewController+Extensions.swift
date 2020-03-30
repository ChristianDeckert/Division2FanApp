//
//  UIViewController+Extensions.swift
//  Division2FanApp
//
//  Created by Christian on 16.03.19.
//  Copyright © 2019 Christian Deckert. All rights reserved.
//

import UIKit

public extension UIViewController {
  static var topMostViewController: UIViewController? {
    return topViewController()
  }

  static var root: UIViewController? {
    return UIApplication.shared.delegate?.window??.rootViewController
  }

  static func topViewController(in viewController: UIViewController? = nil) -> UIViewController? {
    guard var topViewController = (viewController ?? root) else { return nil }

    func presentedRecursive(of parentViewController: UIViewController) -> UIViewController {
      if let navVC = parentViewController as? UINavigationController, let navTopVc = navVC.topViewController { // navigation controller
        return presentedRecursive(of: navTopVc)
      } else if let tabVC = parentViewController as? UITabBarController, let selectedVc = tabVC.selectedViewController { // tab controller
        return presentedRecursive(of: selectedVc)
      } else if let presentedVC = parentViewController.presentedViewController { // modals
        return presentedRecursive(of: presentedVC)
      } else {
        return parentViewController
      }
    }

    return presentedRecursive(of: topViewController)
  }

  public func add(childViewController: UIViewController, animation: UIView.Animations, embed: Bool = true, insets: UIEdgeInsets = .zero, duration: TimeInterval = 0.3, complete: (() -> Void)? = nil) {
    childViewController.willMove(toParent: self)
    childViewController.beginAppearanceTransition(true, animated: animation.isAnimated)

    childViewController.view.alpha = 0
    if embed {
      NSLayoutConstraint.embed(view: childViewController.view, in: view, insets: insets)
    } else {
      view.addSubview(childViewController.view)
    }

    if animation.isAnimated {
      childViewController.view.animate(in: animation, fromCurrentState: false, completion: { _ in
        self.addChild(childViewController)
        childViewController.endAppearanceTransition()
        childViewController.didMove(toParent: self)
        complete?()
      })
    } else {
      childViewController.view.alpha = 1
      self.addChild(childViewController)
      childViewController.endAppearanceTransition()
      childViewController.didMove(toParent: self)
      DispatchQueue.main.async { complete?() }
    }
  }

  public func remove(childViewController: UIViewController, animation: UIView.Animations = .none, complete: (() -> Void)? = nil) {
    childViewController.willMove(toParent: nil)
    childViewController.beginAppearanceTransition(false, animated: animation.isAnimated)

    let localCompletion: (Bool) -> Void = { _ in
      childViewController.view.removeFromSuperview()
      childViewController.endAppearanceTransition()
      childViewController.didMove(toParent: nil)
      complete?()
    }

    if animation.isAnimated {
      childViewController.view.animate(in: animation, completion: localCompletion)
    } else {
      localCompletion(false)
    }

  }
}
