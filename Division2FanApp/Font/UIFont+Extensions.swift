//
//  UIFont+Extensions.swift
//  Division2FanApp
//
//  Created by Christian on 15.03.19.
//  Copyright © 2019 Christian Deckert. All rights reserved.
//

import UIKit

extension UIFont {
  static var borda: UIFont! {
   return UIFont(name: "Borda", size: 14)
  }
  
  static var bordaHeading: UIFont! {
    return UIFont(name: "Borda-Regular4", size: 20)
  }
  
  static var bordaTitle1: UIFont! {
    return UIFont(name: "Borda-Regular3", size: 24)
  }
  
//  static var bordaCaption1: UIFont? {
//    let font = UIFont(name: "Borda", size: UIFont.systemFontSize)
//    let fontMetrics = UIFontMetrics(forTextStyle: .caption1)
//    return fontMetrics.scaledFont(for: font!)
//  }
  
}
