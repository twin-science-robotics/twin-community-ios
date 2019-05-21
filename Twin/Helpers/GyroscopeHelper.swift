//
//  GyroscopeHelper.swift
//  Twin
//
//  Created by Burak Üstün on 9.11.2018.
//  Copyright © 2018 TWIN. All rights reserved.
//

import Foundation
import CoreMotion

enum Orientation: String {
  case left
  case right
  case up
  case down
}

class GyroscopeHelper: NSObject {

  let manager = CMMotionManager()

  override init() {
    super.init()
      manager.accelerometerUpdateInterval = 1
      manager.startAccelerometerUpdates(to: .main) { (data, _) in
        guard let xValue = data?.acceleration.x, let yValue = data?.acceleration.y else { return }
        let angle = atan2(xValue, yValue)
        switch angle {
        case -2.25 ... -0.25:
          Utils.shared.orientation = .down
        case -1.75 ... 0.75:
          Utils.shared.orientation = .right
        case 0.75 ... 2.25:
          Utils.shared.orientation = .up
        default:
          Utils.shared.orientation = .left
        }
      }
  }

}
