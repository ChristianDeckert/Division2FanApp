//
//  CalcualtorTableViewController.swift
//  Division2FanApp
//
//  Created by Christian on 15.03.19.
//  Copyright © 2019 Christian Deckert. All rights reserved.
//

import UIKit

class CalcualtorTableViewController: UITableViewController {
  
  private var statController: StatCollectionViewCellController?
  var rowControllers = [RowControlling]() {
    didSet {
      tableView?.reloadData()
    }
  }
  
  private let userDefaultsService: UserDefaultsService
  private weak var statsDataSource: StatsDataSource?
  
  init(
    rowControllers: [RowControlling],
    userDefaultsService: UserDefaultsService = .shared,
    statsDataSource: StatsDataSource?
    ) {
    self.statsDataSource = statsDataSource
    self.userDefaultsService = userDefaultsService
    self.rowControllers = rowControllers
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(cellNibNamed: "CalculatorCell")
    
    tableView.contentInset = UIEdgeInsets(
      top: 0,
      left: 0,
      bottom: 256,
      right: 0
    )
        
    tableView.backgroundView = nil
    tableView.backgroundColor = .clear
    tableView.delegate = self
  }
}

// MARK: - Table view data source

extension CalcualtorTableViewController {
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return rowControllers[indexPath.row].preferredHeight ?? 44
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

