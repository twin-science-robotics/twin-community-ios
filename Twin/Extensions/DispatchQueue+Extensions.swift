//
//  DispatchQueue+Extensions.swift
//  Twin
//
//  Created by Burak Üstün on 21.05.2019.
//  Copyright © 2019 YGA. All rights reserved.
//

import Dispatch
import Foundation

public extension DispatchQueue {
  static var userInteractive: DispatchQueue { return DispatchQueue.global(qos: .userInteractive) }
  static var userInitiated: DispatchQueue { return DispatchQueue.global(qos: .userInitiated) }
  static var utility: DispatchQueue { return DispatchQueue.global(qos: .utility) }
  static var background: DispatchQueue { return DispatchQueue.global(qos: .background) }
  
  func after(_ delay: TimeInterval, execute closure: @escaping () -> Void) {
    asyncAfter(deadline: .now() + delay, execute: closure)
  }
}

