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
      target: nil,
      action: nil
    )
  }()
  
  private lazy var dpsCalculator = DpsCalculator()
  private lazy var statsCellController = StatsContainerCellController(dpsCalculator: dpsCalculator)
  
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
    
    rowControllers = defaultRowControllers
    
    setBackground()
  }
  
  private func setBackground() {
    let imageView = UIImageView(
      image: UIImage(
        named: "image-background-stone"
      )
    )
    imageView.contentMode = .scaleAspectFill
    tableView.backgroundView = imageView
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationItem.rightBarButtonItem = resetBarButtonItem
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
    
    let result = dpsCalculator.calulate()
    debugPrint(">> result: \(result)")
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
}


