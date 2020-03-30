//
//  UITableView+Extensions.swift
//  Division2FanApp
//
//  Created by Christian on 15.03.19.
//  Copyright © 2019 Christian Deckert. All rights reserved.
//

import UIKit

extension UITableView {

  func register(cellNibNamed name: String, bundle: Bundle? = nil) {
    register(
      UINib(
        nibName: name,
        bundle: bundle
      ),
      forCellReuseIdentifier: name
    )
  }
}
