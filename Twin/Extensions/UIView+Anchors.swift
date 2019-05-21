//
//  UIView+Anchors.swift
//  Buracutils
//
//  Created by Burak Üstün on 13.09.2018.
//

import UIKit

//General
public extension UIView {
  func addSubview(views : UIView...) {
    views.forEach{addSubview($0)}
  }
}

public extension UIView {
  convenience init(backgroundColor : UIColor) {
    self.init(frame: .zero)
    self.backgroundColor = backgroundColor
  }
}

//Anchors
public extension UIView {
  enum constraintType {
    case vertically,horizontally,all
  }
  
  /// Add constraints with visual format
  ///
  /// - Parameters:
  ///   - format: Visual format just change the view names with v0,v1,v2...
  ///   - views: Views for the constraints
  /// - Example:
  /// ``` self.view.addConstraints(_ format: "V:|-20-[v0]-20-|", views:contentView) ```
  func addConstraints(_ format: String, views: UIView...) {
    var viewsDictionary = [String: UIView]()
    for (index, view) in views.enumerated() {
      let key = "v\(index)"
      viewsDictionary[key] = view
      view.translatesAutoresizingMaskIntoConstraints = false
    }
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
  }
  
  /// Fill superview with given view
  ///
  /// - Parameters:
  ///   - constraint: An enum for constraint type
  ///   - ```  public enum constraintType { case vertical,horizontal,both }```
  ///   - view: Our subview
  ///   - space: Space between view and superview layout guide
  func fill(_ constraint : constraintType, with space : CGFloat? = nil) {
    guard let superview = superview else {
      print("‼️ Buracutils: superView cannot be nil!")
      return
    }
    translatesAutoresizingMaskIntoConstraints = false
    var spaceString = ""
    if let space = space {
      spaceString = "-\(space)-"
    }
    switch constraint {
    case .vertically:
      superview.addConstraints("V:|\(spaceString)[v0]\(spaceString)|", views: self)
    case .horizontally:
      superview.addConstraints("H:|\(spaceString)[v0]\(spaceString)|", views: self)
    case .all:
      superview.addConstraints("H:|\(spaceString)[v0]\(spaceString)|", views: self)
      superview.addConstraints("V:|\(spaceString)[v0]\(spaceString)|", views: self)
    }
  }
  
  /// Set aspect ratio for the view.
  ///
  /// - Parameter ratio: height/width
  func setAspectRatio(_ ratio: CGFloat) {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: ratio).isActive = true
  }
  
  /// This function calls the `func addConstraints(_ format: String, views: UIView...)` function and applies it to all subviews
  ///
  /// - Parameter format: Visual format just change the view names with v0,v1,v2...
  func addConstraintsToSubviews(_ format : String) {
    for subview in subviews {
      addConstraints(format, views: subview)
    }
  }
  
  @available(iOS 9.0, *)
  /// Copy constraint from another view
  ///
  /// - Parameter view: The view that you want constraints.
  /// - @available(iOS 9.0, *)
  func copyConstraints(from view : UIView) {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    self.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
  }
}


