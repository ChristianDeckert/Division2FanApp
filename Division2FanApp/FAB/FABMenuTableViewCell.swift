//
//  FABMenuTableViewCell.swift
//  music
//
//  Created by Christian on 14.10.18.
//  Copyright © 2018 Christian Deckert. All rights reserved.
//

import UIKit

class FABMenuTableViewCell: UITableViewCell {

  struct Model {
    let icon: UIImage?
    let text: String?
    let font: UIFont?
    let textColor: UIColor?
  }

  @IBOutlet weak var iconImageView: UIImageView!
  @IBOutlet weak var descriptionLabel: UILabel!

  var model: Model = Model(icon: nil, text: nil, font: nil, textColor: .black) {
    didSet {
      self.iconImageView.image = model.icon
      self.descriptionLabel.text = model.text
      self.descriptionLabel.textColor = model.textColor
      self.descriptionLabel.font = model.font
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {

  }

  override func setHighlighted(_ highlighted: Bool, animated: Bool) {

  }

  override func prepareForReuse() {
    super.prepareForReuse()
    descriptionLabel.text = nil
    iconImageView.image = nil
    alpha = 1
  }

}
