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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "calculator-controller.title".localized
    
    tableView.register(cellNibNamed: "CalculatorCell")
    
    tableView.contentInset = UIEdgeInsets(
      top: 16,
      left: 0,
      bottom: 16,
      right: 0
    )
    
    rowControllers = [
      CalcualtorCellController(title: "calculator-controller.weapon-damage.title".localized),
      CalcualtorCellController(title: "calculator-controller.weapon-damage.title".localized),
      CalcualtorCellController(title: "calculator-controller.weapon-damage.title".localized),
      CalcualtorCellController(title: "calculator-controller.weapon-damage.title".localized),
      CalcualtorCellController(title: "calculator-controller.weapon-damage.title".localized),
      CalcualtorCellController(title: "calculator-controller.weapon-damage.title".localized),
      CalcualtorCellController(title: "calculator-controller.weapon-damage.title".localized),
      CalcualtorCellController(title: "calculator-controller.weapon-damage.title".localized),
      CalcualtorCellController(title: "calculator-controller.weapon-damage.title".localized)
    ]
    
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
    return rowControllers[indexPath.row].preferredHeight ?? 128
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rowControllers.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
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
  
  override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    return false
  }
  
}


