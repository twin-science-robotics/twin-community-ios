//
//  BaseUIViewController.swift
//  Twin
//
//  Created by Burak Üstün on 20.09.2018.
//  Copyright © 2018 TWIN. All rights reserved.
//

import UIKit

class BaseUIViewController: UIViewController {

  enum ConfigureSettings {
    case onlyNavigationBar, navigationBarWithToolbar, blockly
  }

  var width: CGFloat {
    return view.frame.width
  }

  var height: CGFloat {
    return view.frame.height
  }

  let toolBar: UIView = UIView(backgroundColor: .clear)
  
  override var title: String? {
    didSet {
      if let title = title {
        navigationBar?.set(title: title)
      }
    }
  }

  var navigationBar: CustomNavigationBar?
  
  private var tapHandler: (() -> Void)?
  
  let contentView = UIView()
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.setNavigationBarHidden(true, animated: false)
  }

  var navHeight: CGFloat {
    return Utils.shared.isIpad ? 100 : 60
  }

  private var toolBarHeight: CGFloat {
    return Utils.shared.isIpad ? 70 : 50
  }

  @discardableResult
  func buildController(settings: ConfigureSettings,
                       title: String? = nil,
                       sliderItems: [String]? = nil,
                       leftItems: [UIView]? = nil,
                       rightItems: [UIView]? = nil,
                       isTranslucent: Bool = false) -> BaseUIViewController {
    navigationBar = CustomNavigationBar(title: title, sliderItems: sliderItems, leftItems: leftItems, rightItems: rightItems)
    guard let navigationBar = navigationBar else { return self}
    switch settings {
    case .onlyNavigationBar:
      if !isTranslucent {
        view.addSubview(views: navigationBar, contentView)
        view.addConstraints("H:|[v0]|", views: navigationBar)
        view.addConstraints("H:|-30-[v0]-30-|", views: contentView)
        view.addConstraints("V:|[v0(\(navHeight))][v1]|", views: navigationBar, contentView)
      } else {
        view.addSubview(views: contentView, navigationBar)
        view.addConstraints("H:|[v0]|", views: navigationBar)
        view.addConstraints("H:|[v0]|", views: contentView)
        view.addConstraints("V:|[v0(\(navHeight))]", views: navigationBar)
        view.addConstraints("V:|[v0]|", views: contentView)
      }
    case .navigationBarWithToolbar:
      view.addSubview(views: contentView, navigationBar, toolBar)
      if !isTranslucent {
        view.addConstraints("H:|[v0]|", views: navigationBar)
        view.addConstraints("H:|-30-[v0]-30-|", views: contentView)
        view.addConstraints("H:|[v0]|", views: toolBar)
        view.addConstraints("V:|[v0(\(navHeight))][v1][v2(\(toolBarHeight))]|", views: navigationBar, contentView, toolBar)
      } else {
        view.addConstraintsToSubviews("H:|[v0]|")
        view.addConstraints("V:|[v0(\(navHeight))]", views: navigationBar)
        view.addConstraints("V:|[v0][v1(\(toolBarHeight))]|", views: contentView, toolBar)
      }
    case .blockly:
      view.addSubview(views: navigationBar, contentView)
      view.addConstraintsToSubviews("H:|[v0]|")
      view.addConstraints("V:|[v0(\(navHeight))][v1]|", views: navigationBar, contentView)
    }
      return self
  }
  
  func onTitleTap(_ tap: @autoclosure @escaping () -> Void) {
    self.tapHandler = tap
    self.navigationBar?.titleLabel.isUserInteractionEnabled = true
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTitleLabelTap))
    tapRecognizer.numberOfTapsRequired = 2
    self.navigationBar?.titleLabel.addGestureRecognizer(tapRecognizer)
    print("asd")
  }
  
  @objc private func onTitleLabelTap() {
    tapHandler?()
  }
  
  func removeGestureRecognizer() {
    self.tapHandler = nil
    self.navigationBar?.titleLabel.gestureRecognizers?.removeAll()
  }

  func setBackground(color: UIColor) {
    view.backgroundColor = color
    contentView.backgroundColor = color
  }
  
//  override var prefersStatusBarHidden: Bool {
//    return true
//  }

}
