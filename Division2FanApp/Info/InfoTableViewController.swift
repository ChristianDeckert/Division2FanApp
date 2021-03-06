//
//  CalcualtorTableViewController.swift
//  Division2FanApp
//
//  Created by Christian on 15.03.19.
//  Copyright © 2019 Christian Deckert. All rights reserved.
//

import UIKit

class InfoTableViewController: UITableViewController {

  private var rowControllers = [InfoCellController]() {
    didSet {
      tableView?.reloadData()
    }
  }

  private let fabWindow: FABWindow
  init(fabWindow: FABWindow) {
    self.fabWindow = fabWindow
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "info-controller.title".localized

    tableView.register(cellNibNamed: "InfoCell")

    tableView.contentInset = UIEdgeInsets(
      top: 16,
      left: 0,
      bottom: 16,
      right: 0
    )

    setBackgroundImage()

    rowControllers = [
      InfoCellController(
        delegate: self,
        title: "info-controller.about.title".localized,
        text: "info-controller.about.text".localized,
        buttonText: "info-controller.about.button-text".localized,
        link: URL(string: "https://github.com/ChristianDeckert/Division2FanApp")
      ),
      InfoCellController(
        delegate: self,
        title: "info-controller.buy.title".localized,
        text: "info-controller.buy.text".localized,
        buttonText: "info-controller.buy.button-text".localized,
        link: URL(string: "https://store.ubi.com/de/tom-clancy-s-the-division-2-tm-/5b06a3984e0165fa45ffdcc5.html")
      ),
      InfoCellController(
        delegate: self,
        title: "info-controller.buy-epic.title".localized,
        text: "info-controller.buy-epic.text".localized,
        buttonText: "info-controller.buy-epic.button-text".localized,
        link: URL(string: "https://www.epicgames.com/store/de/product/the-division-2/home")
      ),
      InfoCellController(
        delegate: self,
        title: "info-controller.buy-amazon.title".localized,
        text: "info-controller.buy-amazon.text".localized,
        buttonText: "info-controller.buy-amazon.button-text".localized,
        link: URL(string: "https://amzn.to/2TcaifV")
      ),
      InfoCellController(
        delegate: self,
        title: "info-controller.marco.title".localized,
        text: "info-controller.marco.text".localized,
        buttonText: "info-controller.marco.button-text".localized,
        link: URL(string: "https://www.youtube.com/channel/UCQ6_ekp-uPkM0lOuNPVQLFA")
      ),
      InfoCellController(
        delegate: self,
        title: "info-controller.marco-dps.title".localized,
        text: "info-controller.marco-dps.text".localized,
        buttonText: "info-controller.marco-dps.button-text".localized,
        link: URL(string: "https://drive.google.com/file/d/1zR35ayVY5gGslOoAF5hDkrCL4x0KPn3G/view") // Bundle.main.url(forResource: "DPS CALCULATOR MARCOSTYLE", withExtension: "xlsx")
      ),
      InfoCellController(
        delegate: self,
        title: "info-controller.buy-ost.title".localized,
        text: "info-controller.buy-ost.text".localized,
        buttonText: "info-controller.buy-ost.button-text".localized,
        link: URL(string: "https://geo.itunes.apple.com/us/album/tom-clancys-the-division-2-original-game-soundtrack/1451238567?mt=1&app=music&at=1001lShr")
      ),
      InfoCellController(
        delegate: self,
        title: "info-controller.buy-font.title".localized,
        text: "info-controller.buy-font.text".localized,
        buttonText: "info-controller.buy-font.button-text".localized,
        link: URL(string: "http://www.myfonts.com/fonts/northernblock/borda/")
      ),
      InfoCellController(
        delegate: self,
        title: "info-controller.podcast-sitrep.title".localized,
        text: "info-controller.podcast-sitrep.text".localized,
        buttonText: "info-controller.podcast-sitrep.button-text".localized,
        link: URL(string: "https://itunes.apple.com/us/podcast/sitrep-radio-a-podcast-for-the-division-2/id1116429281?mt=2&app=podcast&at=1001lShr")
      ),
      InfoCellController(
        delegate: self,
        title: "info-controller.podcast-diesel.title".localized,
        text: "info-controller.podcast-diesel.text".localized,
        buttonText: "info-controller.podcast-diesel.button-text".localized,
        link: URL(string: "https://itunes.apple.com/us/podcast/the-echo-cast-the-division-2-podcast/id1415297495?mt=2&app=podcast&at=1001lShr")
      ),
      InfoCellController(
        delegate: self,
        title: "info-controller.my-twitter.title".localized,
        text: "info-controller.my-twitter.text".localized,
        buttonText: "info-controller.my-twitter.button-text".localized,
        link: URL(string: "https://twitter.com/machead83")
      )
    ]

  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fabWindow.transistion(to: .hidden)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    fabWindow.transistion(to: .shown)
  }

  private func setBackgroundImage() {
    let imageView = UIImageView(
      image: UIImage(
        named: "image-background"
      )
    )
    imageView.alpha = 1
    imageView.contentMode = .scaleAspectFill
    tableView.backgroundView = imageView
  }
}

// MARK: - Table view data source

extension InfoTableViewController {

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }

  override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rowControllers.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell") as! InfoCell
    cell.setup(with: rowControllers[indexPath.row])
    return cell
  }

}

extension InfoTableViewController: InfoCellControllerDelegate {
  func resetAction() {
  }
}

// MARK: - Table view delegate

extension InfoTableViewController {

  private func shouldHighlight(at indexPath: IndexPath) -> Bool {
    return false
  }

  override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    return shouldHighlight(at: indexPath)
  }

  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return shouldHighlight(at: indexPath) ? indexPath : nil
  }

}
