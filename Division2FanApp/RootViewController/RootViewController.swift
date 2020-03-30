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
    let navigationController = UINavigationController(rootViewController: containerViewController)
    return navigationController
  }()

  lazy var videoPlayerViewController = VideoPlayerViewController(delegate: self)
  lazy var containerViewController = ContainerViewController(fabWindow: self.fabWindow)

  lazy var fabWindow = FABWindow(
    delegate: self,
    tintColor: .primaryTint
  )
  private let userDefaultsService: UserDefaultsService
  init(userDefaultsService: UserDefaultsService = .shared) {
    self.userDefaultsService = userDefaultsService
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .black

    add(childViewController: videoPlayerViewController, animation: .none)

    NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: NSNotification.Name.applicationDidBecomeActive, object: nil)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    guard children.count == 1 else { return }

    let seconds: Int
    if userDefaultsService.boolValue(for: .notFirstStart) {
      seconds = 2
    } else {
      seconds = 5
      userDefaultsService.set(value: true, key: .notFirstStart)
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(seconds)) { [weak self] in
      guard let self = self else { return }
      self.add(childViewController: self.navController, animation: .fade(duration: 0.5))
      self.fabWindow.transistion(to: .shown)
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    switch userDefaultsService.stringValue(for: .recentVideo) {
    case VideoPlayerViewController.Video.darkzoneEast.rawValue:
      videoPlayerViewController.play(video: .streets)
      userDefaultsService.set(
        value: VideoPlayerViewController.Video.streets.rawValue,
        key: .recentVideo
      )
    case VideoPlayerViewController.Video.streets.rawValue:
      videoPlayerViewController.play(video: .night)
      userDefaultsService.set(
        value: VideoPlayerViewController.Video.night.rawValue,
        key: .recentVideo
      )
    default:
      videoPlayerViewController.play(video: .darkzoneEast)
      userDefaultsService.set(
        value: VideoPlayerViewController.Video.darkzoneEast.rawValue,
        key: .recentVideo
      )
    }

    guard !Sounds.shared.isPlaying else { return }
    Sounds.shared.play(effect: .precinctSiege)
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

extension RootViewController: FABDelegate {
  var fabButtonCellsOnTapAction: [FABMenuViewController.Section] {
    return [
      FABMenuViewController.Section(
        cells: [
          FABMenuViewController.Cells.mapBrowser,
          FABMenuViewController.Cells.about
        ],
        name: "Intelligent System Analytic Computer"
      )
    ]
  }

  func fabMenuViewController(_ controller: FABMenuViewController, didSelect cell: FABMenuViewController.Cells) {

    switch cell {
    case .mapBrowser:
      let browser = BrowserViewController(
        destination: .division2map,
        fabWindow: fabWindow
      )
      navController.pushViewController(browser, animated: true)
    case .about:
      let infoController = InfoTableViewController(fabWindow: fabWindow)
      navController.pushViewController(infoController, animated: true)
    }

    fabWindow.toggleFabMenuViewControllerVisibility()
  }
}
