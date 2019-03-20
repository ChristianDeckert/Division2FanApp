//
//  ContainerViewController.swift
//  Division2FanApp
//
//  Created by Christian on 20.03.19.
//  Copyright © 2019 Christian Deckert. All rights reserved.
//

import UIKit

protocol StatsDataSource: class {
  var getDpsCalculator: DpsCalculator? { get }
}

class ContainerViewController: UIViewController {
  
  @IBOutlet weak var collectionContainerView: UIView!
  @IBOutlet weak var tableContainerView: UIView!
  @IBOutlet weak var pageControl: UIPageControl!
  
  lazy var resetBarButtonItem: UIBarButtonItem = {
    return UIBarButtonItem(
      title: "calculator-controller.reset-button.title".localized,
      style: .plain,
      target: self,
      action: #selector(resetAction)
    )
  }()
  
  lazy var infoBarButtonItem: UIBarButtonItem = {
    return UIBarButtonItem(
      title: "calculator-controller.info-button.title".localized,
      style: .plain,
      target: self,
      action: #selector(infoAction)
    )
  }()
  
  private var recentStatIndex: Int = 0
  private var dpsCalculator = DpsCalculator()
  
//  let keyboardNotifications: [NSNotification.Name] = [
//    .keyboardWillShowNotification,
//    .UIResponder.keyboardWillHideNotification,
//    .UIResponder.keyboardWillChangeFrameNotification,
//    ]

  
  private lazy var statsCollectionViewController: StatsCollectionViewController = {
    let statsCollectionViewController = StatsCollectionViewController(
      statsDataSource: self,
      statsDelegate: self,
      startIndex: self.recentStatIndex
    )
    return statsCollectionViewController
  }()
  
  private lazy var calculatorTableViewController: CalcualtorTableViewController = {
    let calcualtorTableViewController = CalcualtorTableViewController(
      rowControllers: exampleRowControllers,
      statsDataSource: self
    )
    return calcualtorTableViewController
  }()
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "container-controller.title".localized
    
    statsCollectionViewController.view.embed(in: collectionContainerView)
    calculatorTableViewController.view.embed(in: tableContainerView)
    
    pageControl.pageIndicatorTintColor = .darkGray
    pageControl.currentPageIndicatorTintColor = .primaryTint
    pageControl.currentPage = recentStatIndex
    pageControl.numberOfPages = 8
    
    navigationController?.navigationBar.blurAppearance()
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationItem.rightBarButtonItem = resetBarButtonItem
    navigationItem.leftBarButtonItem = infoBarButtonItem
    
    guard !Sounds.shared.isPlaying else { return }
    Sounds.shared.play(effect: .precinctSiege)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  @objc func keyboardWillShow(notification: Notification) {
    guard let userInfo = notification.userInfo else { return }
    if let keyboardSize = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
      calculatorTableViewController.tableView.contentInset.bottom = 44 + contentInsets.bottom
//      view.transform = CGAffineTransform.init(translationX: 0, y: -1 * contentInsets.bottom)
    }
  }
  
  @objc func keyboardWillHide(notification: Notification) {
    calculatorTableViewController.tableView.contentInset.bottom = 16
//    view.transform = .identity
  }
}

extension ContainerViewController {
  @objc func resetAction() {
    dpsCalculator = DpsCalculator(
      inputAttributes: [
        DpsCalculator.InputAttribute(
          attribute: .rpm,
          value: 650
        )
      ]
    )
    calculatorTableViewController.rowControllers = defaultRowControllers
    statsCollectionViewController.collectionView.reloadData()
  }
  
  @objc func infoAction() {
    let infoController = InfoTableViewController()
    navigationController?.pushViewController(infoController, animated: true)
  }
}

extension ContainerViewController: StatsDataSource {
  var getDpsCalculator: DpsCalculator? {
    return dpsCalculator
  }
}

extension ContainerViewController: StatsCollectionViewControllerDelegate{
  func didScrollTo(index: Int) {
    recentStatIndex = index
    pageControl.currentPage = index
  }
}

extension ContainerViewController {
  
  var defaultRowControllers: [RowControlling] {
    
    return [
      CalcualtorCellController(
        delegate: self,
        attribute: .weaponDamage,
        value: "5000"
      ),
      CalcualtorCellController(
        delegate: self,
        attribute: .criticalHitChance,
        value: "0",
        placeholder: "0"
      ),
      CalcualtorCellController(
        delegate: self,
        attribute: .criticalHitDamage,
        value: "0",
        placeholder: "0"
      ),
      CalcualtorCellController(
        delegate: self,
        attribute: .headshotDamage,
        value: "0",
        placeholder: "0"
      ),
      CalcualtorCellController(
        delegate: self,
        attribute: .outOfCoverDamage,
        value: "0",
        placeholder: "0"
      ),
      CalcualtorCellController(
        delegate: self,
        attribute: .damageToElites,
        value: "0",
        placeholder: "0"
      ),
      CalcualtorCellController(
        delegate: self,
        attribute: .enemyArmorDamage,
        value: "0",
        placeholder: "0"
      ),
      CalcualtorCellController(
        delegate: self,
        attribute: .healthDamage,
        value: "0",
        placeholder: "0"
      ),
      CalcualtorCellController(
        delegate: self,
        attribute: .rpm,
        value: "650",
        placeholder: "0"
      )
    ]
  }
  
  var exampleRowControllers: [RowControlling] {
    dpsCalculator = DpsCalculator(inputAttributes: [])
    dpsCalculator.add(attribute: .weaponDamage, value: 5000)
    dpsCalculator.add(attribute: .criticalHitChance, value: 30)
    dpsCalculator.add(attribute: .criticalHitDamage, value: 80)
    dpsCalculator.add(attribute: .headshotDamage, value: 110)
    dpsCalculator.add(attribute: .outOfCoverDamage, value: 10)
    dpsCalculator.add(attribute: .damageToElites, value: 20)
    dpsCalculator.add(attribute: .enemyArmorDamage, value: 8)
    dpsCalculator.add(attribute: .healthDamage, value: 5)
    dpsCalculator.add(attribute: .rpm, value: 650)
    return [
      CalcualtorCellController(
        delegate: self,
        attribute: .weaponDamage,
        value: "5000"
      ),
      CalcualtorCellController(
        delegate: self,
        attribute: .criticalHitChance,
        value: "30",
        placeholder: "0"
      ),
      CalcualtorCellController(
        delegate: self,
        attribute: .criticalHitDamage,
        value: "80",
        placeholder: "0"
      ),
      CalcualtorCellController(
        delegate: self,
        attribute: .headshotDamage,
        value: "110",
        placeholder: "0"
      ),
      CalcualtorCellController(
        delegate: self,
        attribute: .outOfCoverDamage,
        value: "10",
        placeholder: "0"
      ),
      CalcualtorCellController(
        delegate: self,
        attribute: .damageToElites,
        value: "20",
        placeholder: "0"
      ),
      CalcualtorCellController(
        delegate: self,
        attribute: .enemyArmorDamage,
        value: "8",
        placeholder: "0"
      ),
      CalcualtorCellController(
        delegate: self,
        attribute: .healthDamage,
        value: "5",
        placeholder: "0"
      ),
      CalcualtorCellController(
        delegate: self,
        attribute: .rpm,
        value: "650",
        placeholder: "650"
      )
    ]
  }
}

// MARK: - CalcualtorCellControllerDelegate

extension ContainerViewController: CalcualtorCellControllerDelegate {
  
  func calcualtorCell(controller: CalcualtorCellController?, didReturnFromTextfieldWith value: String?) {
    
    guard
      let attribute = controller?.attribute,
      let stringValue = value,
      let value = Double(stringValue) else { return }
    
    dpsCalculator.add(
      attribute: attribute,
      value: value
    )
    
    controller?.update(value: value)
    
    statsCollectionViewController.collectionView.reloadData()
  }
  
}


