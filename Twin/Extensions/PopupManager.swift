//
//  PopupManager.swift
//  Twin
//
//  Created by Burak Üstün on 24.09.2018.
//  Copyright © 2018 TWIN. All rights reserved.
//

import UIKit

class PopupManager: NSObject {
  
  enum PopupType {case trash, textField, codeBlock, regular, twoButton, error}
  
  static let standart = PopupManager()
  private var type: PopupType = .regular
  
  var keyWindow: UIWindow? { return UIApplication.shared.keyWindow }
  private var windowWidth: CGFloat { return keyWindow?.frame.width ?? 0 }
  private var windowHeight: CGFloat { return keyWindow?.frame.height ?? 0 }
  
  private lazy var containerView: UIView = {
    let view = UIView(frame: .zero)
    view.backgroundColor = .clear
    return view
  }()
  
  var height: CGFloat {
    switch type {
    case .codeBlock:
      return windowHeight - 150
    case .textField, .error:
      return 200
    case .twoButton:
      return 190
    case .trash:
      return 230
    case .regular:
      return 150
    }
  }
  
  var width: CGFloat {
    switch type {
    case .codeBlock:
      return windowWidth - 150
    default:
      return 300
    }
  }
  
  private var containerVisibleColor: UIColor = UIColor(red: 76, green: 76, blue: 76, transparency: 0.4) ?? .clear
  private var approveHandler:((_ text: String?) -> Void)?
  private var cancelHandler:(() -> Void)?
  private var isVisible: Bool = false
  var popupView: UIView?
  private var textField: UITextField!
  private var titleLabel: UILabel?
  private var canShowNewPopup:Bool = true
  
  // MARK: Functions
  private override init() {
    super.init()
    containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackgroundClick)))
    if !Utils.shared.isIpad {
      
      NotificationCenter.default.addObserver(self,
                                             selector: #selector(keyboardWillShow(_:)),
                                             name: UIResponder.keyboardWillShowNotification,
                                             object: nil)
      NotificationCenter.default.addObserver(self,
                                             selector: #selector(keyboardWillHide(_:)),
                                             name: UIResponder.keyboardWillHideNotification,
                                             object: nil)
    }
  }
  
  @objc func keyboardWillShow(_ notification: Notification) {
    guard let popupView = popupView else { return }
    let height: CGFloat = type == .trash ? 230 : 200
    let width: CGFloat = 300
    popupView.frame = CGRect(x: (windowWidth - width)/2, y: 5, width: width, height: height)
  }
  
  @objc func keyboardWillHide(_ notification: NSNotification) {
    guard let popupView = popupView else { return }
    let height: CGFloat = type == .trash ? 230 : 200
    let width: CGFloat = 300
    popupView.frame =  CGRect(x: (windowWidth - width)/2, y: (windowHeight - height)/2, width: width, height: height)
    
  }
  
  func show(type: PopupType = .regular,
            title: String? = nil,
            yes: String? = nil,
            no: String? = nil,
            text:String? = nil,
            _ approve: ((_ text: String?) -> Void)? = nil,
            onCancel cancel: (() -> Void)? = nil) {
    DispatchQueue.main.async {
      guard self.canShowNewPopup else { return }
      self.popupView = nil
      self.approveHandler = approve
      self.cancelHandler = cancel
      
      self.type = type
      self.popupView = self.build(with: type, title: title, text: text, yes: yes, no: no)
      
      guard let popupView = self.popupView else { return }
      popupView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
      self.keyWindow?.addSubview(self.containerView)
      self.containerView.addSubview(popupView)
      
      self.keyWindow?.addConstraints("V:|[v0]|", views: self.containerView)
      self.keyWindow?.addConstraints("H:|[v0]|", views: self.containerView)
      
      popupView.translatesAutoresizingMaskIntoConstraints = false
      popupView.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor).isActive = true
      popupView.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor).isActive = true
      popupView.heightAnchor.constraint(equalToConstant: self.height).isActive = true
      popupView.widthAnchor.constraint(equalToConstant: self.width).isActive = true
      
      self.canShowNewPopup = false
      UIView.animate(withDuration: 0.15,
                     animations: {
                      popupView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                      self.containerView.backgroundColor = self.containerVisibleColor
                      //                    popupView.layoutIfNeeded()
      },
                     completion: { _ in
                      UIView.animate(withDuration: 0.15) {
                        popupView.transform = .identity
                      }
      })
    }
    
  }
  
  private func build(with type: PopupType, title: String? = nil, text:String? = nil, yes: String? = nil, no: String? = nil) -> UIView {
    let view = UIView(frame: .zero)
    view.layer.cornerRadius = 25
    view.backgroundColor = .white
    switch type {
    case .textField:
      return createTextFieldPopup(with: view, title: title, text: text)
    case .twoButton:
      return createTwoButtonPopup(with: view, title: title, yes: yes, no: no)
    case .trash:
      return createTrashPopup(with: view)
    case .codeBlock:
      return createCodeBlockPopup(with: view, title: title)
    case .regular:
      return createRegularPopup(with: view, title: title, ok: yes)
    case .error:
      return createErrorPopup(with: view, title: title, ok: yes)
    }
  }
  
  public func dismiss(onCompletion : @escaping () -> Void) {
    UIView.animate(withDuration: 0.25, animations: {
      self.containerView.backgroundColor = .clear
      self.popupView?.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
    }, completion: { (_) in
      self.textField = nil
      self.popupView = nil
      self.popupView?.removeFromSuperview()
      self.containerView.removeFromSuperview()
      self.canShowNewPopup = true
      onCompletion()
    })
  }
  
  public func updatePopup(text: String) {
    guard let titleLabel = titleLabel else { return }
    UIView.transition(with: titleLabel, duration: 0.5, options: .transitionCrossDissolve, animations: {
      self.titleLabel?.text = text
    }, completion: nil)
  }
  
  public func destroyHandlers() {
    approveHandler = nil
    cancelHandler = nil
  }
  
  @objc private func onApproveClick() {
    if let textfield = (popupView?.subviews.filter({$0 is UITextField}).first as? UITextField) {
      textfield.resignFirstResponder()
    }
    let text = (popupView?.subviews.filter({$0 is UITextField}).first as? UITextField)?.text
    dismiss(onCompletion: {
      self.approveHandler?(text)
      self.destroyHandlers()
    })
  }
  
  @objc private func onCancelClick() {
    dismiss(onCompletion: {
      self.cancelHandler?()
      self.destroyHandlers()
    })
  }
  
  @objc private func onBackgroundClick() {
    guard let textfield = textField else { return }
    textfield.resignFirstResponder()
  }
}

extension PopupManager: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

extension PopupManager {
  fileprivate func createTrashPopup(with view: UIView) -> UIView {
    let trashIcon = UIImageView(image: #imageLiteral(resourceName: "bigTrashIcon"))
    let subtitle = UILabel(title: "ProjectsViewController_DeleteProject".localized, style: Stylesheet.Label.PopupSubtitle)
    
    let approveButton = UIButton(title: "Global_Yes".localized, style: Stylesheet.Button.popupAquamarine)
    approveButton.addTarget(self, action: #selector(onApproveClick), for: .touchUpInside)
    
    let cancelButton = UIButton(title: "Global_No".localized, style: Stylesheet.Button.popupGreyish)
    cancelButton.addTarget(self, action: #selector(onCancelClick), for: .touchUpInside)
    
    view.addSubview(views: trashIcon, subtitle, approveButton, cancelButton)
    view.addConstraints("V:|-30-[v0(60)][v1(>=30)]-10-[v2(40)]-30-|", views: trashIcon, subtitle, cancelButton)
    view.addConstraints("V:|-30-[v0(60)][v1(>=30)]-10-[v2(40)]-30-|", views: trashIcon, subtitle, approveButton)
    trashIcon.setAspectRatio(1)
    trashIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    view.addConstraints("H:|-40-[v0]-40-|", views: subtitle)
    view.addConstraints("H:|-40-[v0]-10-[v1(==v0)]-40-|", views: cancelButton, approveButton)
    
    return view
  }
  
  fileprivate func createCodeBlockPopup(with view: UIView, title: String?) -> UIView {
    let scrollView = UIScrollView()
    
    let label = UILabel(style: Stylesheet.Label.CodeLabel)
    scrollView.addSubview(label)
    scrollView.addConstraints("V:|-10-[v0]-10-|", views: label)
    scrollView.addConstraints("H:|-10-[v0]-10-|", views: label)
    label.text = title
    
    let cancelButton = UIButton(title: "Global_Ok".localized, style: Stylesheet.Button.popupAquamarine)
    cancelButton.addTarget(self, action: #selector(onCancelClick), for: .touchUpInside)
    
    view.addSubview(views: scrollView, cancelButton)
    view.addConstraints("V:|[v0]-10-[v1(40)]-10-|", views: scrollView, cancelButton)
    view.addConstraints("H:|-10-[v0]-10-|", views: scrollView)
    view.addConstraints("H:|-\((width - 130)/2)-[v0]-\((width - 130)/2)-|", views: cancelButton)
    
    return view
  }
  
  fileprivate func createErrorPopup(with view: UIView, title: String?, ok: String?) -> UIView {
    let okButton = UIButton(title: ok ?? "Global_Ok".localized, style: Stylesheet.Button.popupAquamarine)
    okButton.addTarget(self, action: #selector(onCancelClick), for: .touchUpInside)
    let imageView = UIImageView()
    imageView.image = UIImage(named: "errorIcon")
    titleLabel = UILabel(style: Stylesheet.Label.PopupTitle)
    
    guard let titleLabel = titleLabel else { return UIView() }
    view.addSubview(views: imageView, titleLabel, okButton)
    imageView.setAspectRatio(1)
    imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    view.addConstraints("V:|-20-[v0(60)]-[v1]-[v2(40)]-20-|", views: imageView, titleLabel, okButton)
    view.addConstraints("H:|-20-[v0]-20-|", views: titleLabel)
    view.addConstraints("H:|-\((width - 130)/2)-[v0]-\((width - 130)/2)-|", views: okButton)
    titleLabel.text = title
    return view
  }
  
  fileprivate func createRegularPopup(with view: UIView, title: String?, ok: String?) -> UIView {
    let okButton = UIButton(title: ok ?? "Global_Ok".localized, style: Stylesheet.Button.popupAquamarine)
    okButton.addTarget(self, action: #selector(onCancelClick), for: .touchUpInside)
    
    titleLabel = UILabel(style: Stylesheet.Label.PopupTitle)
    
    guard let titleLabel = titleLabel else { return UIView() }
    view.addSubview(views: titleLabel, okButton)
    view.addConstraints("V:|[v0]-10-[v1(40)]-10-|", views: titleLabel, okButton)
    view.addConstraints("H:|-20-[v0]-20-|", views: titleLabel)
    view.addConstraints("H:|-\((width - 130)/2)-[v0]-\((width - 130)/2)-|", views: okButton)
    titleLabel.text = title
    return view
  }
  
  fileprivate func createTextFieldPopup(with view: UIView, title: String?, text:String?) -> UIView {
    let title = UILabel(title: title, style: Stylesheet.Label.PopupTitle)
    let approveButton = UIButton(title: "Global_Save".localized, style: Stylesheet.Button.popupAquamarine)
    approveButton.addTarget(self, action: #selector(onApproveClick), for: .touchUpInside)
    
    let cancelButton = UIButton(title: "Global_Cancel".localized, style: Stylesheet.Button.popupGreyish)
    cancelButton.addTarget(self, action: #selector(onCancelClick), for: .touchUpInside)
    
    textField = UITextField(style: Stylesheet.TextField.popup)
    textField.delegate = self
    textField.text = text
    
    view.addSubview(views: title, textField, cancelButton, approveButton)
    view.addConstraints("V:|-35-[v0(20)]-10-[v1(45)]-20-[v2(40)]-30-|", views: title, textField, cancelButton)
    view.addConstraints("V:|-35-[v0(20)]-10-[v1(45)]-20-[v2(40)]-30-|", views: title, textField, approveButton)
    view.addConstraints("H:|-40-[v0]-40-|", views: textField)
    view.addConstraints("H:|-40-[v0]-40-|", views: title)
    view.addConstraints("H:|-40-[v0]-10-[v1(==v0)]-40-|", views: cancelButton, approveButton)
    return view
  }
  
  fileprivate func createTwoButtonPopup(with view: UIView, title: String?, yes: String?, no: String?) -> UIView {
    titleLabel = UILabel(title: title, style: Stylesheet.Label.PopupTitle)
    let approveButton = UIButton(title: yes ?? "Global_Yes".localized, style: Stylesheet.Button.popupAquamarine)
    approveButton.addTarget(self, action: #selector(onApproveClick), for: .touchUpInside)
    
    let cancelButton = UIButton(title: no ?? "Global_No".localized, style: Stylesheet.Button.popupGreyish)
    cancelButton.addTarget(self, action: #selector(onCancelClick), for: .touchUpInside)
    
    guard let titleLabel = titleLabel else { return UIView() }
    view.addSubview(views: titleLabel, cancelButton, approveButton)
    view.addConstraints("V:|-30-[v0(70)]-20-[v1(40)]-30-|", views: titleLabel, cancelButton)
    view.addConstraints("V:|-30-[v0(70)]-20-[v1(40)]-30-|", views: titleLabel, approveButton)
    view.addConstraints("H:|-40-[v0]-40-|", views: titleLabel)
    view.addConstraints("H:|-40-[v0]-10-[v1(==v0)]-40-|", views: cancelButton, approveButton)
    return view
  }
}

