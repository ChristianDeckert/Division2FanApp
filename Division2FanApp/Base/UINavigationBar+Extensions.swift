//
//  UINavigationBar+Extensions.swift
//  Division2FanApp
//
//  Created by Christian on 16.03.19.
//  Copyright © 2019 Christian Deckert. All rights reserved.
//

import UIKit

extension UINavigationBar {
  func clearAppearance() {
    setBackgroundImage(UIImage(), for: .default)
    shadowImage = UIImage()
    isTranslucent = true

    for view in subviews {
      guard view.tag == 42 else { continue }
      UIView.animate(withDuration: 0.3, animations: {
        view.alpha = 0
      }, completion: { _ in
        view.removeFromSuperview()
      })
    }
  }

  func blurAppearance(animated: Bool = true) {
    clearAppearance()

    guard nil == subviews.first(where: { $0.tag == 42 }) else { return }

    let containerView = UIView()
    containerView.backgroundColor = .clear
    containerView.tag = 42
    containerView.alpha = 0

    let visualFxView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    visualFxView.embed(in: containerView)

    containerView.embed(in: self, insets: UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 0))
    sendSubviewToBack(containerView)

    containerView.animate(in: .fade(duration: 0.3))
  }
}
