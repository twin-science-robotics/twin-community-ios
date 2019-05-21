//
//  TwoPartCollectionViewCell.swift
//  Twin
//
//  Created by Burak Üstün on 20.09.2018.
//  Copyright © 2018 TWIN. All rights reserved.
//

import UIKit

class TwoPartCollectionViewCell: UICollectionViewCell {

  let view = UIView(style: Stylesheet.View.shadow)
  let topView = UIView(backgroundColor: .white)
  let bottomView = UIView(backgroundColor: .white)

  convenience init(ratio: CGFloat) {
    self.init()
    self.defaultRatio = ratio
    configureBaseViews()
    configureViews()
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureBaseViews()
    configureViews()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  var defaultRatio: CGFloat = 3/4

  private func configureBaseViews() {
    addSubview(view)
    addConstraints("H:|-5-[v0]-5-|", views: view)
    addConstraints("V:|-10-[v0]-10-|", views: view)
    view.layer.cornerRadius = 30
    view.clipsToBounds = true
    view.addSubview(views: topView, bottomView)
    view.addConstraints("H:|[v0]|", views: topView)
    view.addConstraints("H:|[v0]|", views: bottomView)
    topView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: defaultRatio).isActive = true
    bottomView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1 - defaultRatio).isActive = true
    view.addConstraints("V:|[v0][v1]|", views: topView, bottomView)
  }

  func configureViews() {}
}
