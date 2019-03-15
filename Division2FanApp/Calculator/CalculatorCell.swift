//
//  CalculatorCell.swift
//  Division2FanApp
//
//  Created by Christian on 15.03.19.
//  Copyright © 2019 Christian Deckert. All rights reserved.
//

import UIKit


final class CalcualtorCellController: RowControlling {
  
  var preferredHeight: CGFloat? {
    return 128
  }
  
  var title: String?
  var value: String?
  
  init(title: String? = nil, value: String? = nil) {
    self.title = title
    self.value = value
  }
}

final class CalculatorCell: UITableViewCell {
  
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var visualEffectView: UIVisualEffect!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
  }
  override func setHighlighted(_ highlighted: Bool, animated: Bool) {
  }
}

extension CalculatorCell: RowControlable {
  
  typealias T = CalcualtorCellController
  
  func setup(with rowController: T) {
    label.text = rowController.title
    label.font = UIFont.bordaHeading
  }
    
}
