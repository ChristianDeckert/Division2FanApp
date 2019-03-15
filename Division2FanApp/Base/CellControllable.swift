//
//  CellControllable.swift
//  Division2FanApp
//
//  Created by Christian on 15.03.19.
//  Copyright © 2019 Christian Deckert. All rights reserved.
//

import UIKit

protocol RowControlling {
  
  var preferredHeight: CGFloat? { get }
  var preferredFont: UIFont? { get }
  var preferredTintColor: UIColor? { get }
  
}

protocol RowControlable: class {
  
  associatedtype CONTROLLER: RowControlling
  
  func setup(with rowController: CONTROLLER)
  
}

extension RowControlling {
  
  var preferredFont: UIFont? {
    return UIFont.borda
  }
}

