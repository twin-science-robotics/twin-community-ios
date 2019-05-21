//
//  Utils.swift
//  Twin
//
//  Created by Burak Üstün on 20.09.2018.
//  Copyright © 2018 TWIN. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion

class Utils {
  static let shared = Utils()

  private init() {}

  func calculateFontSize(with size: CGFloat) -> CGFloat {
    return getScaledConstraint(size)
  }

  var isIpad: Bool {
      return UIDevice.current.userInterfaceIdiom == .pad
  }
  
  var isWideScreen: Bool {
    if UIDevice().userInterfaceIdiom == .phone {
      switch UIScreen.main.nativeBounds.height {
      case 2436, 2688, 1792:
        return true
      default:
        return false
      }
    } else {
      return true
    }
  }
  let projectColors = ["#03d8c8", "#ff787f", "#8F83AA", "#FDD387", "#8AD570"]

  var orientation: Orientation?

  var didShake: Bool = false {
    didSet {
      print(didShake)
      if didShake {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          self.didShake = false
        }
      }
    }
  }

  //Original const is based on iPhone X
  func getScaledConstraint(_ const: CGFloat) -> CGFloat {
    guard let width = UIApplication.shared.keyWindow?.frame.width else {
      print("‼️ keyWindow is probably nil")
      return 0
    }
    return width * const/812
  }

  class func normalization(width: CGFloat, offSet: CGFloat, minValue: CGFloat = 0) -> CGFloat {
    var result = ((offSet - minValue) / (width - minValue))
    if result < 0 { result = 0 }
    if result > 1 { result = 1 }
    return result
  }

  class func const(_ const: CGFloat) -> CGFloat {
    guard let width = UIApplication.shared.keyWindow?.frame.width else {
      print("‼️ keyWindow is probably nil")
      return 0
    }
    return width * const/812
  }

}


