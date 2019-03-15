//
//  CalculatorCell.swift
//  Division2FanApp
//
//  Created by Christian on 15.03.19.
//  Copyright © 2019 Christian Deckert. All rights reserved.
//

import UIKit

enum Attribute {
  case weaponDamage
  case criticalHitChance
  case criticalHitDamage
  case headshotDamage
  case outOfCoverDamage
  case enemyArmorDamage
  case healthDamage
  case rpm
  
  
  var description: String {
    switch self {
    case .weaponDamage: return "calculator-controller.weapon-damage.title".localized
    case .criticalHitChance: return "calculator-controller.crit-chance.title".localized
    case .criticalHitDamage: return "calculator-controller.crit-damage.title".localized
    case .headshotDamage: return "calculator-controller.headshot-damage.title".localized
    case .outOfCoverDamage: return "calculator-controller.out-of-cover-damage.title".localized
    case .enemyArmorDamage: return "calculator-controller.enemy-armor-damage.title".localized
    case .healthDamage: return "calculator-controller.health-damage.title".localized
    case .rpm: return "calculator-controller.rpm.title".localized
    }
  }
}

protocol CalcualtorCellControllerDelegate: class {
  func calcualtorCell(controller: CalcualtorCellController?, didReturnFromTextfieldWith: String?)
}

final class CalcualtorCellController: RowControlling {
  var preferredTintColor: UIColor? {
    return .primaryTint
  }
  
  
  var preferredHeight: CGFloat? {
    return 128
  }
  
  var attribute: Attribute
  var title: String?
  var value: String?
  var placeholder: String?
  weak var delegate: CalcualtorCellControllerDelegate?
  
  init(
    delegate: CalcualtorCellControllerDelegate?,
    attribute: Attribute,
    value: String? = nil,
    placeholder: String? = "calculator-cell.textfield.placeholder".localized
    ) {
    self.attribute = attribute
    self.title = attribute.description
    self.value = value
    self.placeholder = placeholder
    self.delegate = delegate
  }
}

final class CalculatorCell: UITableViewCell {
  
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var textfield: UITextField!
  @IBOutlet weak var visualEffectView: UIVisualEffect!
  
  private var controller: CalcualtorCellController?
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

}

extension CalculatorCell: RowControlable {
  
  typealias CONTROLLER = CalcualtorCellController
  
  func setup(with rowController: CONTROLLER) {
    self.controller = rowController
    
    label.text = rowController.title
    label.font = .bordaHeading
    
    textfield.text = rowController.value
    textfield.font = .bordaCaption1
    textfield.textColor = rowController.preferredTintColor
    textfield.delegate = self
  }
    
}

extension CalculatorCell: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    controller?.delegate?.calcualtorCell(controller: controller, didReturnFromTextfieldWith: textfield.text)
   textField.resignFirstResponder()
    return true
  }
}
