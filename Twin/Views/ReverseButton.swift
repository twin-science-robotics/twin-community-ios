//
//  ReverseButton.swift
//  Twin
//
//  Created by Burak Üstün on 21.09.2018.
//  Copyright © 2018 TWIN. All rights reserved.
//

import UIKit

class ReverseButton: UIButton {
  override func layoutSubviews() {
    super.layoutSubviews()
    let imageWidth: CGFloat = imageView?.frame.size.width ?? 0
    let titleWidth: CGFloat = titleLabel?.frame.size.width ?? 0
    titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: imageWidth + 3)
    imageEdgeInsets = UIEdgeInsets(top: 0, left: titleWidth, bottom: 0, right: -titleWidth - 3)
  }
}
