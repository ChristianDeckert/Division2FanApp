//
//  VideoPlayerViewController.swift
//  Division2FanApp
//
//  Created by Christian on 16.03.19.
//  Copyright © 2019 Christian Deckert. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit


protocol VideoPlayerViewControllerDelegate: NSObjectProtocol {
  func videoPlayerViewController(_ controller: VideoPlayerViewController, didChangePlaybackState state: VideoPlayerViewController.State)
  func videoPlayerViewController(_ controller: VideoPlayerViewController, didFinishPlaybackAt url: URL)
  
}

final class VideoPlayerViewController: UIViewController {

  
  enum Video: String {
    case streets = "division2-streets"  
    case darkzoneEast = "division2-dz-east"
  }
  
  
  enum State {
    case playing
    case paused
    case finished
  }
  
  lazy var playerViewController = AVPlayerViewController()
  
  var player: AVPlayer? {
    willSet {
      guard let player = self.player else { return }
      removeKvo(player: player)
    }
    didSet {
      guard let player = self.player else { return }
      setupKvo(player: player)
    }
  }
  
  var isPlaying: Bool {
    return state == .playing
  }
  
  var state: State = .paused
  
  var rate: Float {
    set {
      player?.rate = newValue
    }
    get {
      return player?.rate ?? 1
    }
  }
  
  private var url: URL? = nil
  private var oldSuperView: UIView?
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  weak var delegate: VideoPlayerViewControllerDelegate?
  
  init(delegate: VideoPlayerViewControllerDelegate? = nil) {
    super.init(nibName: nil, bundle: nil)
    self.delegate = delegate
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNotifications()
    
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  private func setupNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(avPlayerItemDidPlayToEndTimeAction(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(avPlayerItemTimeJumped(notification:)), name: NSNotification.Name.AVPlayerItemTimeJumped, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(avPlayerItemErrorLogEntry(notification:)), name: NSNotification.Name.AVPlayerItemNewErrorLogEntry, object: nil)
    
    
    //    NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackgroundNotificationAction(notification:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
    //
    //    NotificationCenter.default.addObserver(self, selector: #selector(willEnterForegroundNotificationAction(notification:)), name: UIApplication.willEnterForegroundNotification, object: nil)
  }
  
  func setupKvo(player: AVPlayer) {
    player.addObserver(self, forKeyPath: "timeControlStatus", options: .new, context: nil)
  }
  
  func removeKvo(player: AVPlayer) {
    player.removeObserver(self, forKeyPath: "timeControlStatus")
  }
  
}

extension VideoPlayerViewController {
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == "timeControlStatus" {
      avTimeControlStatusChanged()
    }
  }
}

extension VideoPlayerViewController {
  
  @objc func avPlayerItemDidPlayToEndTimeAction(notification: Notification) {
    guard let url = self.url else { return }
    delegate?.videoPlayerViewController(self, didFinishPlaybackAt: url)
  }
  
  @objc func avPlayerItemErrorLogEntry(notification: Notification) {
    debugPrint(">> VideoPlayerViewController: avPlayerItemErrorLogEntry: \(notification)")
  }
  
  @objc func avPlayerItemTimeJumped(notification: Notification) {
    
  }
  
  func avTimeControlStatusChanged() {
    guard let player = self.player else { return }
    switch player.timeControlStatus {
    case .paused:
      debugPrint(">> VideoPlayerViewController: paused ...")
      DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
        self.delegate?.videoPlayerViewController(self, didChangePlaybackState: .paused)
      }
      self.state = .paused
      
    case .playing:
      debugPrint(">> VideoPlayerViewController: playing ...")
      DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
        self.delegate?.videoPlayerViewController(self, didChangePlaybackState: .playing)
      }
      self.state = .playing
      
    default:
      break
    }
  }
  
  @objc func didEnterBackgroundNotificationAction(notification: Notification) {
    guard state == .playing else { return }
    self.oldSuperView = playerViewController.view.superview
    playerViewController.view.removeFromSuperview()
  }
  
  @objc func willEnterForegroundNotificationAction(notification: Notification) {
    guard let oldSuperView = self.oldSuperView, self.url != nil else {
      return
    }
    oldSuperView.insertSubview(playerViewController.view, at: 0)
    playerViewController.view.frame = oldSuperView.bounds
    
  }
}

extension VideoPlayerViewController {
  
  func loop() {
    player?.seek(to: CMTime.zero)
    player?.play()
  }
  
  func play(video: Video) {
    guard let path = Bundle.main.path(forResource: video.rawValue, ofType:"mov") else {
      debugPrint("Video not found")
      return
    }
    _ = play(url: URL(fileURLWithPath: path))
  }
  
  @discardableResult func play(url: URL) -> Bool {
    self.url = url
    let player = AVPlayer(url: url)
    player.volume = 0
    
    playerViewController.showsPlaybackControls = false
    playerViewController.videoGravity = .resizeAspectFill
    playerViewController.player = player
    self.player = player
    view.insertSubview(playerViewController.view, at: 0)
    playerViewController.view.frame = view.bounds

    setCategory()
    
    player.play()
    return true
  }
  
  
  private func setCategory() {
    do {
      try AVAudioSession.sharedInstance().setCategory(
        AVAudioSession.Category.ambient,
        mode: AVAudioSession.Mode.default,
        options: AVAudioSession.CategoryOptions.mixWithOthers
      )
      
      debugPrint(">> successfully set audio category")
    } catch {
      debugPrint(">> failed to set audio category \(error)")
    }
  }
  
  func playPauseAction() {
    
    if let _ = self.player {
      stopAction(remove: false)
    } else {
      _ = playAction()
    }
    
  }
  
  func stopAction(remove: Bool) {
    state = .paused
    player?.pause()
    guard remove else { return }
    playerViewController.player = nil
    playerViewController.view.removeFromSuperview()
  }
  
  func playAction() -> Bool {
    if let player = player {
      player.play()
      return true
    }
    
    return false
  }
  
}

