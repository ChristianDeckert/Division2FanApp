//
//  BrowserViewController.swift
//  Division2FanApp
//
//  Created by Christian on 26.03.19.
//  Copyright © 2019 Christian Deckert. All rights reserved.
//

import UIKit
import WebKit

final class BrowserViewController: UIViewController {

  enum Destination: String {

    case division2map = "https://division2map.com"

  }
  @IBOutlet weak var webKitView: WKWebView! {
    didSet {
      webKitView?.allowsBackForwardNavigationGestures = false
      webKitView?.alpha = 0.01
      webKitView?.navigationDelegate = self
    }
  }

  private let destination: Destination
  private let fabWindow: FABWindow
  init(
    destination: Destination,
    fabWindow: FABWindow
    ) {
    self.destination = destination
    self.fabWindow = fabWindow
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    guard let url = URL(string: destination.rawValue) else { return }
    let request = URLRequest(url: url)
    webKitView.load(request)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fabWindow.transistion(to: .shown)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fabWindow.transistion(to: .hidden)
  }
}

extension BrowserViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    guard webKitView.alpha < 1 else { return }
    UIView.animate(withDuration: 0.3) {
      self.webKitView.alpha = 1
    }
  }
}

extension BrowserViewController: WKUIDelegate {
}
