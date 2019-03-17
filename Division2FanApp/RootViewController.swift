//
//  RootViewController.swift
//  Division2FanApp
//
//  Created by Christian on 16.03.19.
//  Copyright © 2019 Christian Deckert. All rights reserved.
//

import UIKit

final class RootViewController: UIViewController {
  
  lazy var navController: UINavigationController = {
    let navigationController = UINavigationController(rootViewController: calculatorViewController)
    return navigationController
  }()
  
  lazy var videoPlayerViewController = VideoPlayerViewController(delegate: self)
  lazy var calculatorViewController = CalcualtorTableViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

      add(childViewController: videoPlayerViewController, animation: .none)
      
      NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: NSNotification.Name.applicationDidBecomeActive, object: nil)
    }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    guard children.count == 1 else { return }
    videoPlayerViewController.play(video: .whitehouse)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) { [weak self] in
      guard let self = self else { return }
      self.add(childViewController: self.navController, animation: .fade(duration: 0.5))
    }
    
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  @objc func didBecomeActive() {
    _ = videoPlayerViewController.playAction()
  }
}

extension RootViewController: VideoPlayerViewControllerDelegate {
  func videoPlayerViewController(_ controller: VideoPlayerViewController, didChangePlaybackState state: VideoPlayerViewController.State) {
    
  }
  
  func videoPlayerViewController(_ controller: VideoPlayerViewController, didFinishPlaybackAt url: URL) {
    videoPlayerViewController.loop()
  }
}
