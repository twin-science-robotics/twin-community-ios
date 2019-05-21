//
//  UIFont+Extensions.swift
//  Twin
//
//  Created by Burak Üstün on 30.09.2018.
//  Copyright © 2018 TWIN. All rights reserved.
//

import UIKit

extension UIFont {

  class func museoSans(ofSize size: CGFloat, weight: FontWeight) -> UIFont {
    switch weight {
    case .ms100:
      return UIFont(name: "MuseoSansRounded-100", size: size)!
    case .ms300:
      return UIFont(name: "MuseoSansRounded-300", size: size)!
    case .ms500:
      return UIFont(name: "MuseoSansRounded-500", size: size)!
    case .ms700:
      return UIFont(name: "MuseoSansRounded-700", size: size)!
    case .ms900:
      return UIFont(name: "MuseoSansRounded-900", size: size)!
    case .ms1000:
      return UIFont(name: "MuseoSansRounded-1000", size: size)!
    }
  }

  enum FontWeight {
    case ms100, ms300, ms500, ms700, ms900, ms1000
  }
}
