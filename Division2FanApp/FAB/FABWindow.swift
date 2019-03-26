//
//  FABWindow.swift
//  music
//
//  Created by Christian on 08.10.18.
//  Copyright © 2018 Christian Deckert. All rights reserved.
//

import Foundation
import UIKit

protocol MenuWindowDelegate: class {
  func menuWindowBackgroundBButtonAction()
}


protocol FABDelegate: FABMenuViewControllerDelegate {
  var fabButtonCellsOnTapAction: [FABMenuViewController.Section] { get }
}
  
final class FABWindow: UIWindow {
  
  final class MenuWindow: UIWindow {
    
    lazy var backgroundButton: UIButton = {
      let button = UIButton(frame: self.bounds)
      button.setTitle(nil, for: .normal)
      button.embed(in: self)
      button.addTarget(self, action: #selector(backgroundButtonAction), for: .touchUpInside)
      return button
    }()
    
    weak var delegate: MenuWindowDelegate!
    
    func setup(delegate: MenuWindowDelegate) {
      self.delegate = delegate
      backgroundButton.addTarget(self, action: #selector(backgroundButtonAction), for: .touchUpInside)
    }
    
    @objc func backgroundButtonAction() {
      delegate.menuWindowBackgroundBButtonAction()
    }
    
  }
  
  enum Visibility {
    case hidden
    case shown
  }
  
  lazy var menuWindow: MenuWindow = {
    let window = MenuWindow()
    window.windowLevel = UIWindow.Level.normal + 3
    window.backgroundColor = UIColor.black.withAlphaComponent(0.85)
    window.resignKey()
    window.isHidden = true
    window.clipsToBounds = true
    window.frame = UIScreen.main.bounds
    window.alpha = 0
    let viewController = UIViewController()
    viewController.view.backgroundColor = .clear
    viewController.view.isUserInteractionEnabled = false
    window.rootViewController = viewController
    window.setup(delegate: self)
    return window
  }()
  
  lazy var fabViewController: FabViewController = {
    let viewController = FabViewController(delegate: self)
    viewController.view.alpha = 0
    return viewController
  }()
  
  lazy var fabMenuViewController: FABMenuViewController = {
    let viewController = FABMenuViewController(
      delegate: self.delegate
    )
    viewController.view.backgroundColor = buttonTintColor
    return viewController
  }()
  
  private var preferredFrame: CGRect = .zero
  
  private var delegate: FABDelegate
  private var buttonTintColor: UIColor
  
  init(delegate: FABDelegate, tintColor: UIColor) {
    self.delegate = delegate
    buttonTintColor = tintColor
    super.init(frame: UIScreen.main.bounds)
    
    windowLevel = UIWindow.Level.normal + 1
    backgroundColor = .clear
    resignKey()
    isHidden = true
    clipsToBounds = false
    
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  fileprivate func initialSetup() {
    
    let bottom: CGFloat
    switch UIDevice.current.screenType {
    case .iPhone_XR, .iPhones_X_XS, .iPhone_XSMax:
      bottom = 88
    default:
      bottom = 64.0
    }
    let width: CGFloat = 56
    if preferredFrame == .zero {
      preferredFrame = CGRect(
        x: bounds.width - width - 24,
        y: bounds.height - bottom - width,
        width: width,
        height: width
      )
    }
    
    guard fabViewController.view.superview == nil else { return }
    self.rootViewController = fabViewController
    fabViewController.view.embed(in: self)
    fabViewController.buttonBackgroundView.backgroundColor = buttonTintColor
  }
  
}

// MARK: - Presentation
extension FABWindow {
  
  func transistion(to newVisibilty: Visibility, animated: Bool = true, completion: (() -> Void)? = nil) {
    
    initialSetup()
    self.frame = preferredFrame
    isHidden = false
    UIView.animate(withDuration: 0.4) {
      let opacity: CGFloat
      switch newVisibilty {
      case .shown:
        opacity = 1
      case .hidden:
        opacity = 0
      }
      
      self.fabViewController.view.alpha = opacity
    }
    
  }
  
}


extension FABWindow: FabViewControllerDelegate {
  
  func toggleFabMenuViewControllerVisibility() {
    UIView.animate(withDuration: 0.4, animations: {
      if self.menuWindow.alpha == 0 {
        self.menuWindow.alpha = 1
        self.fabMenuViewController.view.transform = .identity
      } else {
        self.menuWindow.alpha = 0
        self.fabMenuViewController.view.transform = .init(translationX: 0, y: UIScreen.main.bounds.height * 0.6)
      }
    }) { _ in
      self.menuWindow.isUserInteractionEnabled = self.menuWindow.alpha > 0
    }
  }
  
  fileprivate func prepareMenuIfNeeded() {
    
    var bottom: CGFloat = 56
    if #available(iOS 11.0, *) {
      bottom += UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    } else {
      bottom += 0
    }
    
    if menuWindow.isHidden { // first setup
      fabMenuViewController.view.transform = .init(translationX: 0, y: UIScreen.main.bounds.height * 0.6)
      menuWindow.isHidden = false
      fabMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false
      menuWindow.addSubview(fabMenuViewController.view)

      fabMenuViewController.view.leadingAnchor.constraint(
        equalTo: menuWindow.rootViewController!.view.leadingAnchor,
        constant: 8
        ).isActive = true
      fabMenuViewController.view.trailingAnchor.constraint(
        equalTo: menuWindow.rootViewController!.view.trailingAnchor,
        constant: -8
        ).isActive = true
      

      fabMenuViewController.view.bottomAnchor.constraint(
        equalTo: menuWindow.rootViewController!.view.bottomAnchor,
        constant: -8 - bottom
        ).isActive = true
    }

    var height: CGFloat = 0
    
    for (sectionIndex, section) in fabMenuViewController.sections.enumerated() {
      height += 44.0 // section header
      for (rowIndex, _) in section.cells.enumerated() {
        height += fabMenuViewController.tableView(
          fabMenuViewController.tableView,
          heightForRowAt: IndexPath(
            row: rowIndex,
            section: sectionIndex
          )
        )
      }
    }
    
    fabMenuViewController.view.topAnchor.constraint(
      equalTo: menuWindow.rootViewController!.view.topAnchor,
      constant: UIScreen.main.bounds.height - height - bottom
      ).isActive = true
  }
  
  func fabButtonTapped() {
    presentFabMenu(items: delegate.fabButtonCellsOnTapAction)
  }
  
  func presentFabMenu(items: [FABMenuViewController.Section]) {
    
    fabMenuViewController.sections = items
    
    prepareMenuIfNeeded()
    
    toggleFabMenuViewControllerVisibility()
  }
  
}


extension FABWindow: MenuWindowDelegate {
  func menuWindowBackgroundBButtonAction() {
    guard menuWindow.alpha > 0 else { return }
    toggleFabMenuViewControllerVisibility()
  }
  
  
}

