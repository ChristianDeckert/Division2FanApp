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
  case damageToElites
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
    case .damageToElites: return "calculator-controller.damage-to-elites.title".localized
    case .rpm: return "calculator-controller.rpm.title".localized
    }
  }
}

enum Category {
  case bodyshot
  case headshot
  case critBodyShot
  case critHeadShot
}


final class DpsCalculator {
  
  static let defaultWeaponDamage: Double = 5000
  
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
    if !has(attribute: .weaponDamage) {
      add(attribute: .weaponDamage, value: DpsCalculator.defaultWeaponDamage)
    }
  }
  
  private func has(attribute: Attribute) -> Bool {
    return inputAttributes.first(where: { $0.attribute == attribute }) != nil
  }
  
  private func value(of attribute: Attribute) -> Double {
    return inputAttributes.first(where: { $0.attribute == attribute })?.value ?? 0
  }
  
  func add(attribute: Attribute, value: Double) {
    if let existing = inputAttributes.firstIndex(where: { $0.attribute == attribute }) {
      inputAttributes.remove(at: existing)
    }
    
    inputAttributes.insert(DpsCalculator.InputAttribute(
      attribute: attribute,
      value: value
      )
    )
  }
  
  func calulate(stat: StatsCollectionViewController.Stat, category: Category) -> Double {
    let weaponDamageValue = value(of: .weaponDamage)
    guard weaponDamageValue > 0 else { return 0 }
    
    
    var result: Double = 0
    switch stat {
    case .npcInCoverHealth:
      let healthDamageValue = value(of: .healthDamage)
      switch category {
      case .bodyshot:
        result = weaponDamageValue * (1 + healthDamageValue / 100)
      case .headshot:
        let headshotDamage = value(of: .headshotDamage)
        result = weaponDamageValue * (1 + healthDamageValue / 100) * (1 + headshotDamage / 100)
      case .critBodyShot:
        let criticalHitDamage = value(of: .criticalHitDamage)
        result = weaponDamageValue * (1 + healthDamageValue / 100) * (1 + criticalHitDamage / 100)
      case .critHeadShot:
        let criticalHitDamage = value(of: .criticalHitDamage)
        let headshotDamage = value(of: .headshotDamage)
        result = weaponDamageValue * (1 + healthDamageValue / 100) * (1 + criticalHitDamage / 100 + headshotDamage / 100)
      }
      
    case .eliteNpcInCoverHealth:
      let healthDamageValue = value(of: .healthDamage)
      let damageToElites = value(of: .damageToElites)
      switch category {
      case .bodyshot:
        result = weaponDamageValue * (1 + healthDamageValue / 100) * (1 + damageToElites / 100)
      case .headshot:
        let headshotDamage = value(of: .headshotDamage)
        result = weaponDamageValue * (1 + healthDamageValue / 100) * (1 + headshotDamage / 100) * (1 + damageToElites / 100)
      case .critBodyShot:
        let criticalHitDamage = value(of: .criticalHitDamage)
        result = weaponDamageValue * (1 + healthDamageValue / 100) * (1 + criticalHitDamage / 100) * (1 + damageToElites / 100)
      case .critHeadShot:
        let criticalHitDamage = value(of: .criticalHitDamage)
        let headshotDamage = value(of: .headshotDamage)
        result = weaponDamageValue * (1 + healthDamageValue / 100) * (1 + criticalHitDamage / 100 + headshotDamage / 100) * (1 + damageToElites / 100)
      }

    case .npcOutOfCoverHealth:
      
      let outOfCoverDamage = value(of: .outOfCoverDamage)
      let healthDamageValue = value(of: .healthDamage)
      switch category {
      case .bodyshot:
        result = weaponDamageValue * (1 + healthDamageValue / 100) * (1 + outOfCoverDamage / 100)
      case .headshot:
        let headshotDamage = value(of: .headshotDamage)
        result = weaponDamageValue * (1 + healthDamageValue / 100) * (1 + headshotDamage / 100) * (1 + outOfCoverDamage / 100)
      case .critBodyShot:
        let criticalHitDamage = value(of: .criticalHitDamage)
        result = weaponDamageValue * (1 + healthDamageValue / 100) * (1 + criticalHitDamage / 100) * (1 + outOfCoverDamage / 100)
      case .critHeadShot:
        let criticalHitDamage = value(of: .criticalHitDamage)
        let headshotDamage = value(of: .headshotDamage)
        result = weaponDamageValue * (1 + healthDamageValue / 100) * (1 + criticalHitDamage / 100 + headshotDamage / 100) * (1 + outOfCoverDamage / 100)
      }
      
    case .eliteNpcOutOfCoverHealth:
      
      let outOfCoverDamage = value(of: .outOfCoverDamage)
      let damageToElites = value(of: .damageToElites)
      let healthDamageValue = value(of: .healthDamage)
      switch category {
      case .bodyshot:
        result = weaponDamageValue * (1 + healthDamageValue / 100) * (1 + outOfCoverDamage / 100) * (1 + damageToElites / 100)
      case .headshot:
        let headshotDamage = value(of: .headshotDamage)
        result = weaponDamageValue * (1 + healthDamageValue / 100) * (1 + headshotDamage / 100) * (1 + outOfCoverDamage / 100) * (1 + damageToElites / 100)
      case .critBodyShot:
        let healthDamageValue = value(of: .healthDamage)
        let criticalHitDamage = value(of: .criticalHitDamage)
        result = weaponDamageValue * (1 + healthDamageValue / 100) * (1 + criticalHitDamage / 100) * (1 + outOfCoverDamage / 100) * (1 + damageToElites / 100)
      case .critHeadShot:
        let healthDamageValue = value(of: .healthDamage)
        let criticalHitDamage = value(of: .criticalHitDamage)
        let headshotDamage = value(of: .headshotDamage)
        result = weaponDamageValue * (1 + healthDamageValue / 100) * (1 + criticalHitDamage / 100 + headshotDamage / 100) * (1 + outOfCoverDamage / 100) * (1 + damageToElites / 100)
      }
      
    case .npcInCoverArmor:
      let armorDamageValue = value(of: .enemyArmorDamage)
      switch category {
      case .bodyshot:
        result = weaponDamageValue * (1 + armorDamageValue / 100)
      case .headshot:
        let headshotDamage = value(of: .headshotDamage)
        result = weaponDamageValue * (1 + armorDamageValue / 100) * (1 + headshotDamage / 100)
      case .critBodyShot:
        let criticalHitDamage = value(of: .criticalHitDamage)
        result = weaponDamageValue * (1 + armorDamageValue / 100) * (1 + criticalHitDamage / 100)
      case .critHeadShot:
        let criticalHitDamage = value(of: .criticalHitDamage)
        let headshotDamage = value(of: .headshotDamage)
        result = weaponDamageValue * (1 + armorDamageValue / 100) * (1 + criticalHitDamage / 100 + headshotDamage / 100)
      }
      
    case .eliteNpcInCoverArmor:
      let armorDamageValue = value(of: .enemyArmorDamage)
      let damageToElites = value(of: .damageToElites)
      switch category {
      case .bodyshot:
        result = weaponDamageValue * (1 + armorDamageValue / 100) * (1 + damageToElites / 100)
      case .headshot:
        let headshotDamage = value(of: .headshotDamage)
        result = weaponDamageValue * (1 + armorDamageValue / 100) * (1 + headshotDamage / 100) * (1 + damageToElites / 100)
      case .critBodyShot:
        let criticalHitDamage = value(of: .criticalHitDamage)
        result = weaponDamageValue * (1 + armorDamageValue / 100) * (1 + criticalHitDamage / 100) * (1 + damageToElites / 100)
      case .critHeadShot:
        let criticalHitDamage = value(of: .criticalHitDamage)
        let headshotDamage = value(of: .headshotDamage)
        result = weaponDamageValue * (1 + armorDamageValue / 100) * (1 + criticalHitDamage / 100 + headshotDamage / 100) * (1 + damageToElites / 100)
      }
      
    case .npcOutOfCoverArmor:
      
      let outOfCoverDamage = value(of: .outOfCoverDamage)
      let armorDamageValue = value(of: .enemyArmorDamage)
      switch category {
      case .bodyshot:
        result = weaponDamageValue * (1 + armorDamageValue / 100) * (1 + outOfCoverDamage / 100)
      case .headshot:
        let headshotDamage = value(of: .headshotDamage)
        result = weaponDamageValue * (1 + armorDamageValue / 100) * (1 + headshotDamage / 100) * (1 + outOfCoverDamage / 100)
      case .critBodyShot:
        let criticalHitDamage = value(of: .criticalHitDamage)
        result = weaponDamageValue * (1 + armorDamageValue / 100) * (1 + criticalHitDamage / 100) * (1 + outOfCoverDamage / 100)
      case .critHeadShot:
        let criticalHitDamage = value(of: .criticalHitDamage)
        let headshotDamage = value(of: .headshotDamage)
        result = weaponDamageValue * (1 + armorDamageValue / 100) * (1 + criticalHitDamage / 100 + headshotDamage / 100) * (1 + outOfCoverDamage / 100)
      }
      
    case .eliteNpcOutOfCoverArmor:
      
      let outOfCoverDamage = value(of: .outOfCoverDamage)
      let damageToElites = value(of: .damageToElites)
      let armorDamageValue = value(of: .enemyArmorDamage)
      switch category {
      case .bodyshot:
        result = weaponDamageValue * (1 + armorDamageValue / 100) * (1 + outOfCoverDamage / 100) * (1 + damageToElites / 100)
      case .headshot:
        let headshotDamage = value(of: .headshotDamage)
        result = weaponDamageValue * (1 + armorDamageValue / 100) * (1 + headshotDamage / 100) * (1 + outOfCoverDamage / 100) * (1 + damageToElites / 100)
      case .critBodyShot:
        let criticalHitDamage = value(of: .criticalHitDamage)
        result = weaponDamageValue * (1 + armorDamageValue / 100) * (1 + criticalHitDamage / 100) * (1 + outOfCoverDamage / 100) * (1 + damageToElites / 100)
      case .critHeadShot:        
        let criticalHitDamage = value(of: .criticalHitDamage)
        let headshotDamage = value(of: .headshotDamage)
        result = weaponDamageValue * (1 + armorDamageValue / 100) * (1 + criticalHitDamage / 100 + headshotDamage / 100) * (1 + outOfCoverDamage / 100) * (1 + damageToElites / 100)
      }

    }
    
    
    return result
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

