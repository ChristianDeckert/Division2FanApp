//
//  StatsContainerCell.swift
//  Division2FanApp
//
//  Created by Christian on 15.03.19.
//  Copyright © 2019 Christian Deckert. All rights reserved.
//

import UIKit

final class StatsContainerCellController: RowControlling {
  var preferredHeight: CGFloat? { return 256 }
  
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
  @IBOutlet weak var pageControl: UIPageControl!
  
  var controller: CONTROLLER?
  
  private lazy var collectionViewController: StatsCollectionViewController = {
    let collectionViewController = StatsCollectionViewController(dpsCalculator: nil)
    collectionViewController.view.frame = collectionViewContainer.bounds
    collectionViewContainer.addSubview(collectionViewController.view)
    return collectionViewController
  }()
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
}


extension StatsContainerCell: RowControlable {
  typealias CONTROLLER = StatsContainerCellController
  
  func setup(with rowController: CONTROLLER) {
    self.controller = rowController
    pageControl.pageIndicatorTintColor = .darkGray
    pageControl.currentPageIndicatorTintColor = rowController.preferredTintColor
    collectionViewController.dpsCalculator = rowController.dpsCalculator
  }
  
}

