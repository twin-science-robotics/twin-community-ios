//
//  NotificationName+Extensions.swift
//  Twin
//
//  Created by Burak Üstün on 21.03.2019.
//  Copyright © 2019 TWIN. All rights reserved.
//

import Foundation

extension Notification.Name {
  static let twinConnected = Notification.Name.init("kTwinConnected")
  static let twinDisconnected = Notification.Name.init("kTwinDisconnected")
  static let javascriptError = Notification.Name.init("kJsError")
}

extension NotificationCenter {
  open func observe(_ observer: Any = self, selector aSelector: Selector, name aName: NSNotification.Name?, object anObject: Any? = nil) {
    addObserver(observer, selector: aSelector, name: aName, object: anObject)
  }
}
