//
//  Sounds.swift
//  Division2FanApp
//
//  Created by Christian on 15.03.19.
//  Copyright © 2019 Christian Deckert. All rights reserved.
//

import UIKit
import AVFoundation

final class Sounds {
  
  enum Effect: String {
    case lootDrop = "Loot Drop Epic"
  }
  
  private var player: AVAudioPlayer?
  
  static let shared = Sounds()
  
  func play(effect: Effect, volume: Float = 0.2) {

    guard
      let path = Bundle.main.path(forResource: effect.rawValue, ofType: "mp3")
      else { return }
 
    do {
      player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
      player?.volume = volume
      player?.play()
    } catch let error {
      debugPrint(error.localizedDescription)
    }
  
  }

}
