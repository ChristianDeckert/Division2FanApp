//
//  StatsContainerCell.swift
//  Division2FanApp
//
//  Created by Christian on 15.03.19.
//  Copyright © 2019 Christian Deckert. All rights reserved.
//

import UIKit

final class StatsContainerCellController: RowControlling {
  var preferredHeight: CGFloat? { return 320 }
  
  var preferredTintColor: UIColor? {
    return .primaryTint
  }
  
  let dpsCalculator: DpsCalculator
  
  init(dpsCalculator: DpsCalculator) {
    self.dpsCalculator = dpsCalculator
  }
}

final class StatsContainerCell: UITableViewCell {
  
  @IBOutlet weak var collectionViewContainer: UIView!
  
  var controller: CONTROLLER?
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
}


extension StatsContainerCell: RowControlable {
  typealias CONTROLLER = StatsContainerCellController
  
  func setup(with rowController: CONTROLLER) {
    self.controller = rowController
  }
  
}
