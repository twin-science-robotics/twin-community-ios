//
//  ProjectsCollectionViewCell.swift
//  Twin
//
//  Created by Burak Üstün on 20.09.2018.
//  Copyright © 2018 TWIN. All rights reserved.
//

import UIKit

class ProjectsCollectionViewCell: TwoPartCollectionViewCell {

  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    return imageView
  }()

  private let title: UILabel = UILabel(style: Stylesheet.Label.cellTitle)
  private var model: ProjectModel?

  private let lockView: UIView = {
    let view = UIView(style: Stylesheet.View.shadow)
    view.backgroundColor = .white
    let imageView = UIImageView(image: #imageLiteral(resourceName: "trashIcon"))
    imageView.contentMode = .scaleAspectFit
    view.addSubview(imageView)
    imageView.fill(.all, with: Utils.const(12.5))
    view.isUserInteractionEnabled = true
    return view
  }()

  override func layoutIfNeeded() {
    super.layoutIfNeeded()
    lockView.layer.cornerRadius = lockView.bounds.size.width/2
  }

  private var index: Int?

  func configureCell(model: ProjectModel) {
    self.model = model
//    print(model.projectID)
    bottomView.backgroundColor = .white
    topView.addSubview(imageView)
    imageView.fill(.all, with: 50)

    switch model.isMine {
    case true:
      bottomView.addSubview(views: title, lockView)
      lockView.setAspectRatio(1)
      bottomView.addConstraints("V:|-12.5-[v0]-12.5-|", views: lockView)
      bottomView.addConstraints("V:|-10-[v0]-10-|", views: title)
      bottomView.addConstraints("H:|-20-[v0]-3-[v1]-20-|", views: title, lockView)

      let tap = UITapGestureRecognizer(target: self, action: #selector(onTrashIconTap(_:)))
      tap.numberOfTapsRequired = 1
      lockView.addGestureRecognizer(tap)
    case false:
      bottomView.addSubview(views: title)
      bottomView.addConstraints("V:|-10-[v0]-10-|", views: title)
      bottomView.addConstraintsToSubviews("H:|-20-[v0]-20-|")
    }
//    if let hexString =  model.topBackgroundColor {
//      topView.backgroundColor = UIColor(hexString: hexString)
//    }

    guard let imageName = model.image else { return }
    DispatchQueue.global(qos: .userInitiated).async {
        let image = UIImage(named: imageName)
        DispatchQueue.main.async {
          self.imageView.image = image
        }
    }

    self.title.text = model.title
    layoutIfNeeded()
  }

  var parent: MyProjectsTableViewCell?

  @objc func onTrashIconTap(_ view: UIView) {
    PopupManager.standart.show(type: .trash, { _ in
      guard let parent = self.parent else { return }
      parent.refresh(self.model?.projectID)
      print("approve")
    }, onCancel: {
      print("cancel")
    })
  }

}

extension UIFont {

  /**
   Will return the best font conforming to the descriptor which will fit in the provided bounds.
   */
  static func bestFittingFontSize(for text: String, in bounds: CGRect, fontDescriptor: UIFontDescriptor, additionalAttributes: [NSAttributedString.Key: Any]? = nil) -> CGFloat {
    let constrainingDimension = min(bounds.width, bounds.height)
    let properBounds = CGRect(origin: .zero, size: bounds.size)
    var attributes = additionalAttributes ?? [:]

    let infiniteBounds = CGSize(width: CGFloat.infinity, height: CGFloat.infinity)
    var bestFontSize: CGFloat = constrainingDimension

    for fontSize in stride(from: bestFontSize, through: 0, by: -1) {
      let newFont = UIFont(descriptor: fontDescriptor, size: fontSize)
      attributes[.font] = newFont

      let currentFrame = text.boundingRect(with: infiniteBounds,
                                           options: [.usesLineFragmentOrigin, .usesFontLeading],
                                           attributes: attributes, context: nil)

      if properBounds.contains(currentFrame) {
        bestFontSize = fontSize
        break
      }
    }
    return bestFontSize
  }

  static func bestFittingFont(for text: String, in bounds: CGRect, fontDescriptor: UIFontDescriptor, additionalAttributes: [NSAttributedString.Key: Any]? = nil) -> UIFont {
    let bestSize = bestFittingFontSize(for: text, in: bounds, fontDescriptor: fontDescriptor, additionalAttributes: additionalAttributes)
    return UIFont(descriptor: fontDescriptor, size: bestSize)
  }
}

extension UILabel {

  /// Will auto resize the contained text to a font size which fits the frames bounds.
  /// Uses the pre-set font to dynamically determine the proper sizing
  func fitTextToBounds() {
    guard let text = text, let currentFont = font else { return }

    let bestFittingFont = UIFont.bestFittingFont(for: text, in: bounds,
                                                 fontDescriptor: currentFont.fontDescriptor,
                                                 additionalAttributes: basicStringAttributes)
    font = bestFittingFont
  }

  private var basicStringAttributes: [NSAttributedString.Key: Any] {
    var attribs = [NSAttributedString.Key: Any]()

    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = self.textAlignment
    paragraphStyle.lineBreakMode = self.lineBreakMode
    attribs[.paragraphStyle] = paragraphStyle

    return attribs
  }
}
