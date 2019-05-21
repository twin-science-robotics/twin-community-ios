//
//  AddNewProjectCollectionViewCell.swift
//  Twin
//
//  Created by Burak Üstün on 20.09.2018.
//  Copyright © 2018 TWIN. All rights reserved.
//

import UIKit

class AddNewProjectCollectionViewCell: TwoPartCollectionViewCell {

  private let backView: UIView = {
    let view = UIView(backgroundColor: .white)
    view.layer.cornerRadius = 35
    let imageView = UIImageView(image: #imageLiteral(resourceName: "plusIcon"))
    view.addSubview(views: imageView)
    view.addConstraints("V:|-15-[v0]-15-|", views: imageView)
    view.addConstraints("H:|-15-[v0]-15-|", views: imageView)
    return view
  }()
  private let label = UILabel(title: "BlocklyViewController_NewProject".localized, style: Stylesheet.Label.addItemTitle)

  override init(frame: CGRect) {
    super.init(frame: frame)
    view.subviews.forEach({$0.removeFromSuperview()})
    view.backgroundColor = .aquamarine

    view.addSubview(views: backView, label)
    backView.setAspectRatio(1)
    backView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
    backView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    backView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    
    label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 35).isActive = true
    label.heightAnchor.constraint(equalToConstant: 50).isActive = true
    view.addConstraints("H:|-10-[v0]-10-|", views: label)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
