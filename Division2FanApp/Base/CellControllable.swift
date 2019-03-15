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
  
}

protocol RowControlable: class {
  
  associatedtype T: RowControlling
  
  func setup(with rowController: T)
  
}

extension RowControlling {
  
  var preferredFont: UIFont? {
    return UIFont.borda
  }
}

