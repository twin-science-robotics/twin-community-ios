//
//  TwoPartViewController.swift
//  Twin
//
//  Created by Burak Üstün on 9.10.2018.
//  Copyright © 2018 TWIN. All rights reserved.
//

import UIKit

class TwoPartViewController: BaseUIViewController {

  convenience init(animated: Bool) {
    self.init()
    self.isAnimated = animated
  }

  private let mainImageView: UIImageView = {
    let imageView = UIImageView(style: Stylesheet.ImageView.fill)
    imageView.image = UIImage(named: Utils.shared.isIpad ? "loginWallpaper_iPad" : "loginWallpaper")
    imageView.alpha = 1
    return imageView
  }()

  var backImage: UIImage? {
    didSet {
      guard let image = backImage else { return }
      mainImageView.image = image
    }
  }

  let container = UIView(backgroundColor: .white)
  private let topContainer = UIView(backgroundColor: .white)
  let centerContainer = UIView(backgroundColor: .white)
  let bottomContainer = UIView(backgroundColor: .white)
  private let titleLabel = UILabel(style: Stylesheet.Label.MainTitle)
  var keyboardWillShow:((_ height: CGFloat) -> Void)?
  var keyboardWillHide:(() -> Void)?
  private var isAnimated:Bool = true
  private var leading:NSLayoutConstraint?

  private var logoHeight: CGFloat {
    return Utils.shared.isIpad ? 70 : 40
  }

  private var buttonHeight: CGFloat {
    return Utils.shared.isIpad ? 80 : 50
  }

  private var containerWidth: CGFloat {
    return -(self.view.frame.width/2)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
    let backButton = UIButton(style: Stylesheet.Button.back, action: #selector(backToParentController(_:)))
    buildController(settings: .onlyNavigationBar, title: "", leftItems: [backButton], isTranslucent: true)
    view.backgroundColor = .darkBlueGreen
    let tap = UITapGestureRecognizer(target: self, action: #selector(onGradientImageTap))
    self.view.addGestureRecognizer(tap)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillShow(_:)),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillHide(_:)),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if isAnimated {
      animate(isAppear: true)
    }
  }

  @objc func keyboardWillShow(_ notification: Notification) {
    guard let userInfo = notification.userInfo else { return }
    if let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
      keyboardWillShow?(keyboardSize)
    }

  }

  @objc func keyboardWillHide(_ notification: NSNotification) {
    keyboardWillHide?()
  }

  func configureViews() {
    view.addSubview(views: mainImageView )
    mainImageView.fill(.all)
    contentView.addSubview(container)
    container.fill(.vertically)
    container.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/2).isActive = true
    leading = container.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: isAnimated ? 0 : containerWidth)
    leading?.isActive = true
    container.addSubview(views: topContainer, centerContainer, bottomContainer)
    container.subviews.forEach({$0.fill(.horizontally)})
    container.addConstraints("V:|[v0(\(height/7))][v1(\(4.5 * height/7))][v2(\(1.5 * height/7))]|", views: topContainer, centerContainer, bottomContainer)
    titleLabel.textColor = .black
    topContainer.addSubview(views: titleLabel)
    titleLabel.fill(.all)
  }

  func animate(isAppear: Bool, completion: ((Bool) -> Void)? = nil) {
    leading?.constant = isAppear ? containerWidth : 0
    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
      self.contentView.layoutIfNeeded()
    }, completion: completion)
  }

}

extension TwoPartViewController {
  @objc func backToParentController(_ button: UIButton) {
    if isAnimated {
      animate(isAppear: false) { (_) in
        self.dismiss(animated: false, completion: nil)
      }
    } else {
      dismiss(animated: false, completion: nil)
    }
  }

  func set(title: String) {
    self.titleLabel.text = title
  }

  @objc private func onGradientImageTap() {
    view.endEditing(true)
  }
}
