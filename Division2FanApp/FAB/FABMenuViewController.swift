//
//  FABMenuViewController.swift
//  music
//
//  Created by Christian on 14.10.18.
//  Copyright © 2018 Christian Deckert. All rights reserved.
//

import UIKit

protocol FABMenuViewControllerDelegate: class {
  func fabMenuViewController(_ controller: FABMenuViewController, didSelect cell: FABMenuViewController.Cells)
}

final class FABMenuViewController: UIViewController {
  
  struct Section {
    var cells: [Cells]
    var name: String
    var numberOfItems: Int {
      return cells.count
    }
    
    func item(at indexPath: IndexPath) -> Cells {
      return cells[indexPath.item]
    }
  }
  
  enum Cells {
    case mapBrowser
    case about
    
    var title: String {
      switch self {
      case .mapBrowser: return "fab-menu.map-browser.title".localized
      case .about: return "fab-menu.map-browser.about".localized
      }
    }
    
    var icon: String {
      switch self {
      case .mapBrowser: return "icon-map"
      case .about: return "icon-info"
      }
    }
  }
  
  @IBOutlet weak var tableView: UITableView!
  
  private weak var delegate: FABMenuViewControllerDelegate!
  
  var sections = [Section]() {
    didSet {
      guard tableView != nil else { return }
      tableView.reloadData()
    }
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  init(delegate: FABMenuViewControllerDelegate) {
    self.delegate = delegate
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.backgroundColor = .clear
    tableView.backgroundView?.backgroundColor = .clear
    
    for nib in ["FABMenuTableViewCell"] {
      tableView.register(UINib(nibName: nib, bundle: nil), forCellReuseIdentifier: nib)
    }
    
    view.layer.cornerRadius = 16
    view.clipsToBounds = true
  }
}


extension FABMenuViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return sections.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 44.0
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sections[section].numberOfItems
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "FABMenuTableViewCell") as! FABMenuTableViewCell
    
    let currentItem = sections[indexPath.section].item(at: indexPath)
    switch currentItem {
    default:
      cell.model = FABMenuTableViewCell.Model(
        icon: UIImage(named: currentItem.icon),
        text: currentItem.title,
        font: .bordaHeading,
        textColor: .black
      )
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    tableView.isUserInteractionEnabled = false
    
    UIView.animate(withDuration: 0.3, animations: {
      for (index, cell) in self.tableView.visibleCells.enumerated() where index != indexPath.row {
        cell.alpha = 0.2
      }
    }) { _ in
      self.delegate.fabMenuViewController(
        self, didSelect:
        self.sections[indexPath.section].item(at: indexPath)
      )
      tableView.isUserInteractionEnabled = true
    }
    
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let title = sections[section].name

    let headerLabel = UILabel()
    headerLabel.font = .borda
    headerLabel.text = "   \(title)".uppercased()
    headerLabel.textColor = .black
    return headerLabel
  }
  
}


