//
//  StatCollectionViewCell.swift
//  Division2FanApp
//
//  Created by Christian on 15.03.19.
//  Copyright © 2019 Christian Deckert. All rights reserved.
//

import UIKit

final class StatCollectionViewCellController: RowControlling {
  var preferredHeight: CGFloat? { return nil }
  
  var preferredTintColor: UIColor? { return .primaryTint }
  
  let stat: StatsCollectionViewController.Stat
  let statsDataSource: StatsCollectionViewControllerDataSource?
  init(stat: StatsCollectionViewController.Stat, statsDataSource: StatsCollectionViewControllerDataSource?) {
    self.stat = stat
    self.statsDataSource = statsDataSource
  }
}

final class StatCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var bodyTitleLabel: UILabel! {
    didSet {
      bodyTitleLabel.text = "stats-collection-controller.body-shot.title".localized
      bodyTitleLabel.font = .bordaSubtitle
    }
  }
  @IBOutlet weak var bodyValueLabel: UILabel!{
    didSet {
      bodyValueLabel.text = "0"
      bodyValueLabel.font = .bordaSubtitle
      bodyValueLabel.textColor = .primaryTint
    }
  }
  
  @IBOutlet weak var bodyCritTitleLabel: UILabel!{
    didSet {
      bodyCritTitleLabel.text = "stats-collection-controller.body-shot-critical.title".localized
      bodyCritTitleLabel.font = .bordaSubtitle
    }
  }
  @IBOutlet weak var bodyCritValueLabel: UILabel! {
    didSet {
      bodyCritValueLabel.text = "0"
      bodyCritValueLabel.font = .bordaSubtitle
      bodyCritValueLabel.textColor = .primaryTint
    }
  }
  
  @IBOutlet weak var headTitleLabel: UILabel!{
    didSet {
      headTitleLabel.text = "stats-collection-controller.head-shot.title".localized
      headTitleLabel.font = .bordaSubtitle
    }
  }
  @IBOutlet weak var headValueLabel: UILabel! {
    didSet {
      headValueLabel.text = "0"
      headValueLabel.font = .bordaSubtitle
      headValueLabel.textColor = .primaryTint
    }
  }
  
  
  @IBOutlet weak var headCritTitleLabel: UILabel!{
    didSet {
      headCritTitleLabel.text = "stats-collection-controller.head-shot-critical.title".localized
      headCritTitleLabel.font = .bordaSubtitle
    }
  }
  @IBOutlet weak var headCritValueLabel: UILabel! {
    didSet {
      headCritValueLabel.text = "0"
      headCritValueLabel.font = .bordaSubtitle
      headCritValueLabel.textColor = .primaryTint
    }
  }
  
  var controller: StatCollectionViewCellController?
  
}

extension StatCollectionViewCell: RowControlable {
  func setup(with rowController: StatCollectionViewCellController) {
    self.controller = rowController
    
    titleLabel.font = .bordaHeading
    titleLabel.text = rowController.stat.description
    
    let bodyValue = Int(rowController.statsDataSource?.dpsCalculator?.calulate(
      stat: rowController.stat,
      category: .bodyshot
      ) ?? 0
    )
    bodyValueLabel.text = "\(bodyValue)"
    
    let headValue = Int(rowController.statsDataSource?.dpsCalculator?.calulate(
      stat: rowController.stat,
      category: .headshot
      ) ?? 0
    )
    headValueLabel.text = "\(headValue)"
    
    let critBodyValue = Int(rowController.statsDataSource?.dpsCalculator?.calulate(
      stat: rowController.stat,
      category: .critBodyShot
      ) ?? 0
    )
    bodyCritValueLabel.text = "\(critBodyValue)"
    
    let critHeadValue = Int(rowController.statsDataSource?.dpsCalculator?.calulate(
      stat: rowController.stat,
      category: .critHeadShot
      ) ?? 0
    )
    headCritValueLabel.text = "\(critHeadValue)"
  }
  
  typealias CONTROLLER = StatCollectionViewCellController
  
}

