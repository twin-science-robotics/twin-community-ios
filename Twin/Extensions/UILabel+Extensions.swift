//
//  UILabel+CustomInit.swift
//  Buracutils
//
//  Created by Burak Üstün on 11.05.2018.
//  Copyright © 2018 YGA. All rights reserved.
//

import UIKit

public extension UILabel {
  convenience init(title : String? = "", style : Style<UILabel>? = nil) {
    self.init()
    if let style = style {
      apply(style)
    }
    text = title
  }
  
  // Baska bir initializer eklemek icin stylesheetteki genel UIView icin yazdigimiz initi override etmemiz gerekiyor.
  convenience init(style: Style<UILabel>) {
    self.init(frame: .zero)
    apply(style)
  }
}

