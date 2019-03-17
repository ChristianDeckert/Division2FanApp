//
//  StatsCollectionViewController.swift
//  Division2FanApp
//
//  Created by Christian on 15.03.19.
//  Copyright © 2019 Christian Deckert. All rights reserved.
//

import UIKit

protocol StatsCollectionViewControllerDataSource: class {
  var dpsCalculator: DpsCalculator? { get }
}

final class StatsCollectionViewController: UICollectionViewController {
  
  enum Stat {
    case npcInCoverHealth
    case eliteNpcInCoverHealth
    case npcOutOfCoverHealth
    case eliteNpcOutOfCoverHealth
    case npcInCoverArmor
    case eliteNpcInCoverArmor
    case npcOutOfCoverArmor
    case eliteNpcOutOfCoverArmor
    
    var description: String {
      switch  self {
      case .npcInCoverHealth:
        return "stats-collection-controller.npc-in-cover-health.title".localized
      case .eliteNpcInCoverHealth:
        return "stats-collection-controller.elite-npc-in-cover-health.title".localized
      case .npcOutOfCoverHealth:
        return "stats-collection-controller.npc-out-of-cover-health.title".localized
      case .eliteNpcOutOfCoverHealth:
        return "stats-collection-controller.elite-npc-out-of-cover-health.title".localized
      case .npcInCoverArmor:
        return "stats-collection-controller.npc-in-cover-armor.title".localized
      case .eliteNpcInCoverArmor:
        return "stats-collection-controller.elite-npc-in-cover-armor.title".localized
      case .npcOutOfCoverArmor:
        return "stats-collection-controller.npc-out-of-cover-armor.title".localized
      case .eliteNpcOutOfCoverArmor:
        return "stats-collection-controller.elite-npc-out-of-cover-armor.title".localized
      }
    }
  }
  
  private weak var statsDataSource: StatsCollectionViewControllerDataSource?
  
  init(statsDataSource: StatsCollectionViewControllerDataSource?) {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    self.statsDataSource = statsDataSource
    super.init(collectionViewLayout: flowLayout)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  var items = [StatCollectionViewCellController]() {
    didSet {
      collectionView?.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.register(UINib(nibName: "StatCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "StatCollectionViewCell")
    collectionView.backgroundColor = .clear
    collectionView.backgroundView = nil
    collectionView.isPagingEnabled = true
    
    items = [
      StatCollectionViewCellController(
        stat: .npcInCoverHealth,
        statsDataSource: statsDataSource
      ),
      StatCollectionViewCellController(
        stat: .eliteNpcInCoverHealth,
        statsDataSource: statsDataSource
      ),      
      StatCollectionViewCellController(
        stat: .npcOutOfCoverHealth,
        statsDataSource: statsDataSource
      ),
      StatCollectionViewCellController(
        stat: .eliteNpcOutOfCoverHealth,
        statsDataSource: statsDataSource
      ),
      StatCollectionViewCellController(
        stat: .npcInCoverArmor,
        statsDataSource: statsDataSource
      ),
      StatCollectionViewCellController(
        stat: .eliteNpcInCoverArmor,
        statsDataSource: statsDataSource
      ),
      StatCollectionViewCellController(
        stat: .npcOutOfCoverArmor,
        statsDataSource: statsDataSource
      ),
      StatCollectionViewCellController(
        stat: .eliteNpcOutOfCoverArmor,
        statsDataSource: statsDataSource
      )
    ]
  }
  
  // MARK: UICollectionViewDataSource
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {    
    return items.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "StatCollectionViewCell",
      for: indexPath
      ) as! StatCollectionViewCell
    
    cell.setup(with: items[indexPath.row])
    
    return cell
  }
  
  // MARK: UICollectionViewDelegate

  override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
    return false
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    return false
  }
  
}

extension StatsCollectionViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return view.bounds.size
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .zero
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}

