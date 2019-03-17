//
//  CalcualtorTableViewController.swift
//  Division2FanApp
//
//  Created by Christian on 15.03.19.
//  Copyright © 2019 Christian Deckert. All rights reserved.
//

import UIKit

class CalcualtorTableViewController: UITableViewController {
  
  private var rowControllers = [RowControlling]() {
    didSet {
      tableView?.reloadData()
    }
  }
  
  lazy var resetBarButtonItem: UIBarButtonItem = {
    return UIBarButtonItem(
      title: "calculator-controller.reset-button.title".localized,
      style: .plain,
      target: self,
      action: #selector(resetAction)
    )
  }()
  
  private lazy var dpsCalculator = DpsCalculator()
  private var statsCellController: StatsContainerCellController {
    return StatsContainerCellController(dpsCalculator: dpsCalculator)
  }
  
  private var initialScrollviewOffsetY: CGFloat?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "calculator-controller.title".localized
    
    tableView.register(cellNibNamed: "StatsContainerCell")
    tableView.register(cellNibNamed: "CalculatorCell")
    
    tableView.contentInset = UIEdgeInsets(
      top: 16,
      left: 0,
      bottom: 16,
      right: 0
    )
    
    rowControllers = exampleRowControllers
    
    navigationController?.navigationBar.blurAppearance()
    tableView.backgroundView = nil
    tableView.backgroundColor = .clear
    tableView.delegate = self
  }
  
  private func setBackgroundImage() {
    let imageView = UIImageView(
      image: UIImage(
        named: "image-background"
      )
    )
    imageView.alpha = 0.8
    imageView.contentMode = .scaleAspectFill
    tableView.backgroundView = imageView
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationItem.rightBarButtonItem = resetBarButtonItem
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
//    Sounds.shared.play(effect: .lootDrop)
    
    guard nil == initialScrollviewOffsetY else { return }
    initialScrollviewOffsetY = tableView.contentOffset.y
  }
}

// MARK: - Table view data source

extension CalcualtorTableViewController {
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 0: return statsCellController.preferredHeight ?? 44
    default: return rowControllers[indexPath.row].preferredHeight ?? 44
    }
    
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 { return 1 }
    
    return rowControllers.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if  indexPath.section == 0 {
      let statsCell = tableView.dequeueReusableCell(
        withIdentifier: "StatsContainerCell",
        for: indexPath
        ) as! StatsContainerCell
      
      statsCell.setup(with: statsCellController)
      
      return statsCell
    }
    
    
    let cell: UITableViewCell
    
    switch rowControllers[indexPath.row] {
    case let calculatorCellController as CalcualtorCellController:
      let calculatorCell = tableView.dequeueReusableCell(
        withIdentifier: "CalculatorCell",
        for: indexPath
        ) as! CalculatorCell
      
      calculatorCell.setup(with: calculatorCellController)
      cell = calculatorCell
    default:
      cell = UITableViewCell()
    }
    
    return cell
  }
  
}

extension CalcualtorTableViewController {
  @objc func resetAction() {
    dpsCalculator = DpsCalculator(inputAttributes: [])
    rowControllers = defaultRowControllers
  }
}

// MARK: - Table view delegate

extension CalcualtorTableViewController {
  
  private func shouldHighlight(at indexPath: IndexPath) -> Bool {
    return false
  }
  
  override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    return shouldHighlight(at: indexPath)
  }
  
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return shouldHighlight(at: indexPath) ? indexPath : nil
  }
  
}

// MARK: - CalcualtorCellControllerDelegate

extension CalcualtorTableViewController: CalcualtorCellControllerDelegate {
  
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
    
    tableView.beginUpdates()
    tableView.reloadSections(IndexSet(integer: 0), with: .none)
    tableView.endUpdates()
  }
  
}

extension CalcualtorTableViewController {
  
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
        placeholder: "650"
      )
    ]
  }
  
  var exampleRowControllers: [RowControlling] {
    
    
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

extension CalcualtorTableViewController {
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
  }
}

