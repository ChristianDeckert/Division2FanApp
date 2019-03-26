//
//  FabViewController.swift
//  music
//
//  Created by Christian on 08.10.18.
//  Copyright © 2018 Christian Deckert. All rights reserved.
//

import UIKit

protocol FabViewControllerDelegate: class {
  func fabButtonTapped()
}

class FabViewController: UIViewController {
  
  @IBOutlet weak var button: UIButton!
  @IBOutlet weak var buttonBackgroundView: UIView!
  private weak var delegate: FabViewControllerDelegate?
  
  init(delegate: FabViewControllerDelegate) {
    self.delegate = delegate
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    buttonBackgroundView.layer.shadowColor = UIColor.black.cgColor
    buttonBackgroundView.layer.shadowRadius = 4
    buttonBackgroundView.layer.shadowOpacity = 0.5
    buttonBackgroundView.layer.cornerRadius = 0.5 * button.bounds.height
  }

}


// MARK: - Actions
extension FabViewController {
  
  @IBAction func buttonAction() {
    delegate?.fabButtonTapped()
  }
  
}
