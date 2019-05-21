//
//  UIButton+Extensions.swift
//  Buracutils
//
//  Created by Burak Üstün on 11.05.2018.
//  Copyright © 2018 YGA. All rights reserved.
//

import UIKit

public extension UIButton {
  convenience init(title : String? = nil,
                   style : Style<UIButton>? = nil,
                   image : UIImage? = nil,
                   insets : UIEdgeInsets? = nil,
                   target : Any? = self,
                   action selector : Selector? = nil,
                   for controlState : UIControl.Event? = .touchUpInside) {
    self.init(frame: .zero)
    if let style = style {
      apply(style)
    }
    if let title = title {
      setTitle(title, for: .normal)
    }
    if let image = image {
      setImage(image, for: .normal)
    }
    if let insets = insets {
      imageEdgeInsets = insets
    }
    if let target = target, let selector = selector, let controlState = controlState {
      self.addTarget(target, action: selector, for: controlState)
    }
  }
  
  convenience init(image : UIImage?,
                   insets: UIEdgeInsets? = nil,
                   frame: CGRect = .barButton) {
    self.init(frame: frame)
    if let image = image {
      setImage(image, for: .normal)
      setTitle(" ", for: .normal)
    }
    if let insets = insets {
      imageEdgeInsets = insets
    }
  }
  
  func setTextColor(_ color : UIColor, forStates states: UIControl.State...) {
    for state in states {
      setTitleColor(color, for: state)
    }
  }
  
  func setTitle(_ title : String, forStates states: UIControl.State...) {
    for state in states {
      setTitle(title, for: state)
    }
  }
  
  // Baska bir initializer eklemek icin stylesheetteki genel UIView icin yazdigimiz initi override etmemiz gerekiyor.
  convenience init(style: Style<UIButton>) {
    self.init(frame: .zero)
    apply(style)
  }
}

public extension CGRect {
  static var barButton:CGRect {
    return CGRect(x: 0, y: 0, width: 32, height: 32)
  }
}

public extension UIButton {
  
  ///   Image of disabled state for button; also inspectable from Storyboard.
  @IBInspectable var imageForDisabled: UIImage? {
    get {
      return image(for: .disabled)
    }
    set {
      setImage(newValue, for: .disabled)
    }
  }
  
  ///   Image of highlighted state for button; also inspectable from Storyboard.
  @IBInspectable var imageForHighlighted: UIImage? {
    get {
      return image(for: .highlighted)
    }
    set {
      setImage(newValue, for: .highlighted)
    }
  }
  
  ///   Image of normal state for button; also inspectable from Storyboard.
  @IBInspectable var imageForNormal: UIImage? {
    get {
      return image(for: .normal)
    }
    set {
      setImage(newValue, for: .normal)
    }
  }
  
  ///   Image of selected state for button; also inspectable from Storyboard.
  @IBInspectable var imageForSelected: UIImage? {
    get {
      return image(for: .selected)
    }
    set {
      setImage(newValue, for: .selected)
    }
  }
  
  ///   Title color of disabled state for button; also inspectable from Storyboard.
  @IBInspectable var titleColorForDisabled: UIColor? {
    get {
      return titleColor(for: .disabled)
    }
    set {
      setTitleColor(newValue, for: .disabled)
    }
  }
  
  ///   Title color of highlighted state for button; also inspectable from Storyboard.
  @IBInspectable var titleColorForHighlighted: UIColor? {
    get {
      return titleColor(for: .highlighted)
    }
    set {
      setTitleColor(newValue, for: .highlighted)
    }
  }
  
  ///   Title color of normal state for button; also inspectable from Storyboard.
  @IBInspectable var titleColorForNormal: UIColor? {
    get {
      return titleColor(for: .normal)
    }
    set {
      setTitleColor(newValue, for: .normal)
    }
  }
  
  ///   Title color of selected state for button; also inspectable from Storyboard.
  @IBInspectable var titleColorForSelected: UIColor? {
    get {
      return titleColor(for: .selected)
    }
    set {
      setTitleColor(newValue, for: .selected)
    }
  }
  
  ///   Title of disabled state for button; also inspectable from Storyboard.
  @IBInspectable var titleForDisabled: String? {
    get {
      return title(for: .disabled)
    }
    set {
      setTitle(newValue, for: .disabled)
    }
  }
  
  ///   Title of highlighted state for button; also inspectable from Storyboard.
  @IBInspectable var titleForHighlighted: String? {
    get {
      return title(for: .highlighted)
    }
    set {
      setTitle(newValue, for: .highlighted)
    }
  }
  
  ///   Title of normal state for button; also inspectable from Storyboard.
  @IBInspectable var titleForNormal: String? {
    get {
      return title(for: .normal)
    }
    set {
      setTitle(newValue, for: .normal)
    }
  }
  
  ///   Title of selected state for button; also inspectable from Storyboard.
  @IBInspectable var titleForSelected: String? {
    get {
      return title(for: .selected)
    }
    set {
      setTitle(newValue, for: .selected)
    }
  }
  
}

// MARK: - Methods
public extension UIButton {
  
  private var states: [UIControl.State] {
    return [.normal, .selected, .highlighted, .disabled]
  }
  
  ///   Set image for all states.
  ///
  /// - Parameter image: UIImage.
  func setImageForAllStates(_ image: UIImage) {
    states.forEach { self.setImage(image, for: $0) }
  }
  
  ///   Set title color for all states.
  ///
  /// - Parameter color: UIColor.
  func setTitleColorForAllStates(_ color: UIColor) {
    states.forEach { self.setTitleColor(color, for: $0) }
  }
  
  ///   Set title for all states.
  ///
  /// - Parameter title: title string.
  func setTitleForAllStates(_ title: String) {
    states.forEach { self.setTitle(title, for: $0) }
  }
  
  ///   Center align title text and image on UIButton
  ///
  /// - Parameter spacing: spacing between UIButton title text and UIButton Image.
  func centerTextAndImage(spacing: CGFloat) {
    let insetAmount = spacing / 2
    imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
    titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
    contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
  }
}

