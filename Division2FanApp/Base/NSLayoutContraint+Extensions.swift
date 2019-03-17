//
//  NSLayoutContraint+Extensions.swift
//  Division2FanApp
//
//  Created by Christian on 16.03.19.
//  Copyright © 2019 Christian Deckert. All rights reserved.
//

import UIKit

public extension NSLayoutConstraint {
  @discardableResult public static func embed(view: UIView, in parentView: UIView, insets: UIEdgeInsets = .zero) -> Bool {
    view.translatesAutoresizingMaskIntoConstraints = false
    parentView.addSubview(view)
    
    let leading = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: .equal, toItem: parentView, attribute: .leading, multiplier: 1.0, constant: insets.left)
    let trailing = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: .equal, toItem: parentView, attribute: .trailing, multiplier: 1.0, constant: insets.right)
    let top = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.top, relatedBy: .equal, toItem: parentView, attribute: .top, multiplier: 1.0, constant: insets.top)
    let bottom = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: .equal, toItem: parentView, attribute: .bottom, multiplier: 1.0, constant: -insets.bottom)
    let constraints = [top, leading, bottom, trailing]
    parentView.addConstraints(constraints)
    
    return true
  }
}
