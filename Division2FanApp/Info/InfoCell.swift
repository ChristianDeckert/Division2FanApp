//
//  CalculatorCell.swift
//  Division2FanApp
//
//  Created by Christian on 15.03.19.
//  Copyright © 2019 Christian Deckert. All rights reserved.
//

import UIKit

protocol InfoCellControllerDelegate: class {

}

final class InfoCellController: RowControlling {
  var preferredTintColor: UIColor? {
    return .primaryTint
  }
  var preferredHeight: CGFloat? {
    return 96
  }

  var title: String?
  var text: String?
  var buttonText: String?
  var link: URL?

  weak var delegate: InfoCellControllerDelegate?

  init(
    delegate: InfoCellControllerDelegate?,
    title: String? = nil,
    text: String? = nil,
    buttonText: String? = nil,
    link: URL? = nil
    ) {
    self.title = title
    self.text = text
    self.buttonText = buttonText
    self.link = link
    self.delegate = delegate
  }

}

final class InfoCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var infoTextLabel: UILabel!
  @IBOutlet weak var button: UIButton!
  @IBOutlet weak var visualEffectView: UIVisualEffect!

  private var controller: CONTROLLER?

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  @IBAction func buttonAction(sender: UIButton) {
    guard let link = controller?.link else { return }
    UIApplication.shared.open(link, options: [:], completionHandler: nil)
  }
}

extension InfoCell: RowControlable {

  typealias CONTROLLER = InfoCellController

  func setup(with rowController: CONTROLLER) {

    titleLabel.text = rowController.title
    titleLabel.font = .bordaHeading

    infoTextLabel.text = rowController.text
    infoTextLabel.font = .bordaSubtitle

    button.setTitle(rowController.buttonText, for: .normal)
    button.isHidden = rowController.link == nil
    button.backgroundColor = rowController.preferredTintColor
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = .bordaSubtitle

    controller = rowController

  }

}
