//
//  StatsCollectionViewController.swift
//  Division2FanApp
//
//  Created by Christian on 15.03.19.
//  Copyright © 2019 Christian Deckert. All rights reserved.
//

import UIKit

protocol StatsCollectionViewControllerDelegate: class {
  func didScrollTo(index: Int)
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

  private weak var statsDataSource: StatsDataSource?
  private weak var statsDelegate: StatsCollectionViewControllerDelegate?
  private var startIndex: Int?
  init(
    statsDataSource: StatsDataSource?,
    statsDelegate: StatsCollectionViewControllerDelegate?,
    startIndex: Int? = nil
    ) {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    self.statsDataSource = statsDataSource
    self.statsDelegate = statsDelegate
    self.startIndex = startIndex
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

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    guard let startIndex = startIndex else { return }
    scroll(to: startIndex)
    self.startIndex = nil
  }

  func scroll(to index: Int, animated: Bool = false) {
    collectionView.scrollToItem(
      at: IndexPath(
        item: index,
        section: 0
      ),
      at: .centeredHorizontally,
      animated: animated
    )
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

extension StatsCollectionViewController {

  override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    updateIndex()
  }

  override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    guard !decelerate else {return }
    updateIndex()
  }

  private func updateIndex() {
    guard collectionView.bounds.size.width > 0 else { return }
    var currentIndex: Int = Int(collectionView.contentOffset.x / collectionView.bounds.size.width)
    if currentIndex < 0 {
      currentIndex = 0
    } else if currentIndex >= items.count {
      currentIndex = items.count - 1
    }
    statsDelegate?.didScrollTo(index: currentIndex)
  }
}
