//
//  Style.swift
//  Buracutils
//
//  Created by Burak Üstün on 13.09.2018.
//

import UIKit

// MARK : StyleSheet Constructors
public struct Style<View: UIView> {
  
  public let style: (View) -> Void
  
  public init(_ style: @escaping (View) -> Void) {
    self.style = style
  }
  
  public func apply(to view: View) {
    style(view)
  }
}

public extension UIView {
  
  convenience init<V>(style: Style<V>) {
    self.init(frame: .zero)
    apply(style)
  }
  
  func apply<V>(_ style: Style<V>) {
    guard let view = self as? V else {
      return
    }
    style.apply(to: view)
  }
  
  @discardableResult
  func style<V>(_ style: Style<V>) -> V {
    guard let view = self as? V else {
      return self as! V
    }
    style.apply(to: view)
    return view
  }
}
