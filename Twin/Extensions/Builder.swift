//
//  Builder.swift
//  Buracutils
//
//  Created by Burak Üstün on 11.01.2019.
//

import Foundation

import UIKit

// Builder allows you to create an instance and setting it up in a simple way

public protocol Builder {}

extension Builder {
  public func with(_ configure: (inout Self) -> Void) -> Self {
    var this = self
    configure(&this)
    return this
  }
}

extension NSObject: Builder {}

public protocol With {}

extension With where Self: AnyObject {
  @discardableResult
  public func with<T>(_ property: ReferenceWritableKeyPath<Self, T>, setTo value: T) -> Self {
    self[keyPath: property] = value
    return self
  }
}

extension UIView: With {}
