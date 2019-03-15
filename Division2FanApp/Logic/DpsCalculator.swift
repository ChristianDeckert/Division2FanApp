//
//  DpsCalculator.swift
//  Division2FanApp
//
//  Created by Christian on 15.03.19.
//  Copyright © 2019 Christian Deckert. All rights reserved.
//

import Foundation
import CommonCrypto

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


struct DpsCalculator {
  
  struct InputAttribute {
    let attribute: Attribute
    let value: Double
  }
    
  var inputAttributes: Set<InputAttribute>
  
  var isValid: Bool {
    return value(of: .weaponDamage) > 0
  }
  
  init(inputAttributes: Set<InputAttribute> = []) {
    self.inputAttributes = inputAttributes
  }
  
  private func value(of attribute: Attribute) -> Double {
    return inputAttributes.first(where: { $0.attribute == attribute })?.value ?? 0
  }
  
  mutating func add(attribute: Attribute, value: Double) {
    if let existing = inputAttributes.firstIndex(where: { $0.attribute == attribute }) {
      inputAttributes.remove(at: existing)
    }
    
    inputAttributes.insert(DpsCalculator.InputAttribute(
      attribute: attribute,
      value: value
      )
    )
  }
  
  func calulate() -> Double {
    
    let weaponDamageValue = value(of: .weaponDamage)
    let healthDamageValue = value(of: .healthDamage)
    
    return weaponDamageValue * (1 + healthDamageValue / 100)
  }
  
}

extension DpsCalculator.InputAttribute: Hashable {
  
  private func sha256() -> Data {
    guard let data = attribute.description.data(using: .utf8) else { return Data() }
    
    var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
    data.withUnsafeBytes {
      _ = CC_SHA256($0, CC_LONG(data.count), &hash)
    }
    return Data(bytes: hash)
  }
  
  var hash: String {
    return sha256().base64EncodedString()
  }
}

