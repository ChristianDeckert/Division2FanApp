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
  
  static var recentIndex: Int?
  
  private var collectionViewController: StatsCollectionViewController?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    guard let recentIndex = StatsContainerCell.recentIndex else { return }
    pageControl.currentPage = recentIndex
  }
  
}


extension StatsContainerCell: RowControlable {
  typealias CONTROLLER = StatsContainerCellController
  
  func setup(with rowController: CONTROLLER) {
    self.controller = rowController
    pageControl.pageIndicatorTintColor = .darkGray
    pageControl.currentPageIndicatorTintColor = rowController.preferredTintColor
    
    for view in collectionViewContainer.subviews {
      view.removeFromSuperview()
    }
    let collectionViewController = StatsCollectionViewController(
      statsDataSource: self,
      statsDelegate: self,
      startIndex: StatsContainerCell.recentIndex
    )
    collectionViewController.view.frame = collectionViewContainer.bounds
    collectionViewController.view.embed(in: collectionViewContainer)   
    self.collectionViewController = collectionViewController
  }
  
}

extension StatsContainerCell: StatsCollectionViewControllerDataSource {
  var dpsCalculator: DpsCalculator? {
    return controller?.dpsCalculator
  }
}

extension StatsContainerCell: StatsCollectionViewControllerDelegate{
  func didScrollTo(index: Int) {
    pageControl.currentPage = index
    StatsContainerCell.recentIndex = index
  }
  

}
