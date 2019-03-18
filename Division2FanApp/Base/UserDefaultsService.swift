//
//  UserDefaultsService.swift
//  Division2FanApp
//
//  Created by Christian on 18.03.19.
//  Copyright © 2019 Christian Deckert. All rights reserved.
//

import UIKit

protocol UserDefaultsServing {
  func boolValue(for key: UserDefaultsService.Keys) -> Bool
  func set(value: Any, key: UserDefaultsService.Keys)
}

final class UserDefaultsService {

  enum Keys: String {
    case notFirstStart
  }
  
  static let shared = UserDefaultsService()
  
  private let defaults: UserDefaults
  init(defaults: UserDefaults = .standard) {
    self.defaults = defaults
  }
  
  func value(for key: Keys) -> Any? {
    return defaults.value(forKey: key.rawValue)
  }
  
  func stringValue(for key: Keys) -> String? {
    return value(for: key) as? String
  }
  
  func boolValue(for key: Keys) -> Bool {
    guard let boolValue = value(for: key) as? Bool else { return false }
    return boolValue
  }
  
  func set(value: Any, key: Keys) {
    defaults.setValue(value, forKeyPath: key.rawValue)
    defaults.synchronize()
  }

}
