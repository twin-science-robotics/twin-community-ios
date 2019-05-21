//
//  NavigationBarCollectionViewCell.swift
//  Twin
//
//  Created by Burak Üstün on 20.09.2018.
//  Copyright © 2018 TWIN. All rights reserved.
//

import UIKit

class NavigationBarCollectionViewCell: UICollectionViewCell {

  private let title: UILabel = UILabel(style: Stylesheet.Label.MainTitle)

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureViews()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configureViews() {
    addSubview(title)
    title.textColor = .pinkishGrey
    addConstraints("V:|[v0]|", views: title)
    addConstraints("H:|[v0]|", views: title)
  }

  func configureCell(with text: String) {
    self.title.text = text
  }

  override var isSelected: Bool {
    didSet {
      self.title.textColor = isSelected ? .black : .pinkishGrey
    }
  }
}
