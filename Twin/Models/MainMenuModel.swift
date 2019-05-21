//
//  MainMenuModel.swift
//  Twin
//
//  Created by Burak Üstün on 20.09.2018.
//  Copyright © 2018 TWIN. All rights reserved.
//

import UIKit

class MainMenuModel {
  enum State { case locked, unlocked}

  var image: UIImage!
  var title: String!
  var topBackgroundColor: UIColor!
  var state: State = .unlocked

  public init(image: UIImage, title: String, topBackgroundColor: UIColor, state: State = .unlocked) {
    self.image = image
    self.title = title
    self.topBackgroundColor = topBackgroundColor
    self.state = state
  }
}
