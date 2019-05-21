//
//  CustomNavigationBar.swift
//  Twin
//
//  Created by Burak Üstün on 20.09.2018.
//  Copyright © 2018 TWIN. All rights reserved.
//

import UIKit

class CustomNavigationBar: UIView {

  init(title: String? = nil, sliderItems: [String]? = nil, leftItems: [UIView]? = nil, rightItems: [UIView]? = nil) {
    super.init(frame: .zero)
    if let title = title {
      self.titleLabel.text = title
    }
    if let sliderItems = sliderItems {
      items.append(contentsOf: sliderItems)
    }
    let rightItemsCount = rightItems?.count ?? 0
    let leftItemsCount = leftItems?.count ?? 0

    var tempRightItems = rightItems
    var tempLeftItems = leftItems

    //Sag sol item sayisini esitliyorum yoksa stackler sacma sapan davraniyor.
    //Fixlenecek ancak suan icin sure yetersiz

    if rightItemsCount < leftItemsCount {
      let difference = leftItemsCount - rightItemsCount
      for _ in 0..<difference {
        tempRightItems?.insert(UIView(backgroundColor: .clear), at: 0)
      }
    } else if leftItemsCount < rightItemsCount {
      let difference = rightItemsCount - leftItemsCount
      for _ in 0..<difference {
        tempLeftItems?.insert(UIView(backgroundColor: .clear), at: leftItemsCount)
      }
    }

    leftStackView =  UIStackView(arrangedSubviews: [])
    rightStackView =  UIStackView(arrangedSubviews: [])

    prepare(stackView: &leftStackView, items: tempLeftItems)
    prepare(stackView: &rightStackView, items: tempRightItems)

    multiplier = (tempLeftItems?.count) ?? 1
    configure(hasSlider: sliderItems != nil)
  }

  var indexChanged: ((IndexPath) -> Void)?
  weak var controller: BaseUIViewController?

  var title: String? {
    return self.titleLabel.text
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func prepare( stackView : inout UIStackView, items: [UIView]?) {
    if let items = items {
      for (button) in items {
        let view = UIView(backgroundColor: .clear)
        view.addSubview(button)
        if (button as? UIButton)?.titleLabel?.text == nil {
          button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
          button.layer.cornerRadius = (CGFloat(itemSize) - roundedItemMargin * 2) / 2.cgFloat
          print((CGFloat(itemSize) - roundedItemMargin * 2) / 2.cgFloat)
          view.addConstraints("H:|-\(roundedItemMargin)-[v0]-\(roundedItemMargin)-|", views: button)
        } else {
          view.addConstraints("H:|[v0]|", views: button)
          button.setAspectRatio(Utils.shared.isIpad ? 0.55 : 0.6)
          button.layer.cornerRadius = CGFloat(itemSize) / 3.5

        }

        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.addArrangedSubview(view)
      }
    }
  }

  private var items: [String] = []
  private var multiplier = 1
  private var roundedItemMargin: CGFloat = Utils.shared.isIpad ? 15 : 10
  private let itemSize: CGFloat = Utils.shared.isIpad ? 80 : 60
  private let itemSpace: CGFloat = 5

  private var constraint: CGFloat {
      return itemSize * multiplier.cgFloat + ((multiplier - 1).cgFloat * itemSpace)
  }

  private let containerView = UIView(backgroundColor: .clear)
  let titleLabel = UILabel(style: Stylesheet.Label.MainTitle)
  var leftStackView: UIStackView!
  var rightStackView: UIStackView!

  lazy var cellSize: CGSize = {
    return  CGSize(width: ((collectionView.frame.width) / CGFloat(items.count)), height: collectionView.frame.height)
  }()

  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.delegate = self
    cv.dataSource = self
    cv.register(cellWithClass: NavigationBarCollectionViewCell.self)
    cv.isScrollEnabled = false
    cv.backgroundColor = .clear
    return cv
  }()

  lazy var indicatorView: UIView = {
    let baseView = UIView(backgroundColor: .clear)
//    let topView = UIView(style: Stylesheet.View.indicator)
    let bottomView = UIView(style: Stylesheet.View.indicator)
    baseView.addSubview(views: bottomView)
    baseView.frame = CGRect(x: collectionView.frame.minX,
                            y: collectionView.frame.minY,
                            width: (collectionView.frame.width / items.count.cgFloat) + 10,
                            height: collectionView.frame.height + 18)

//    topView.frame = CGRect(x: 0, y: 0, width: baseView.frame.width, height: 5)
    bottomView.frame = CGRect(x: 0, y: baseView.frame.height - 3.5, width: baseView.frame.width, height: 3.5)
    return baseView
  }()

  private func configure(hasSlider: Bool) {
    if hasSlider {
      self.backgroundColor = .clear
      titleLabel.textAlignment = .center
      addSubview(containerView)
      addConstraints("V:|-15-[v0]-10-|", views: containerView)
      addConstraints("H:|-10-[v0]-20-|", views: containerView)

      leftStackView.distribution = .fillEqually
      rightStackView.distribution = .fillEqually
      leftStackView.spacing = itemSpace
      rightStackView.spacing = itemSpace

      containerView.addSubview(views: leftStackView, collectionView, rightStackView)
      containerView.addConstraints("H:|-20-[v0(\(constraint))]-60-[v1]-60-[v2(\(constraint))]-20-|", views: leftStackView, collectionView, rightStackView)
      containerView.addConstraintsToSubviews("V:|[v0]|")
      collectionView.reloadData()
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        self.collectionView.selectItem(at: IndexPath(row: 0), animated: false, scrollPosition: [])
        self.addSubview(self.indicatorView)
      }
    } else {
      self.backgroundColor = .clear
      titleLabel.textAlignment = .center
      addSubview(containerView)
      addConstraints("V:|-15-[v0]-10-|", views: containerView)
      addConstraints("H:|-10-[v0]-20-|", views: containerView)

      leftStackView.distribution = .fillEqually
      rightStackView.distribution = .fillEqually
      leftStackView.spacing = itemSpace
      rightStackView.spacing = itemSpace

      containerView.addSubview(views: leftStackView, titleLabel, rightStackView)
      containerView.addConstraints("H:|-20-[v0(\(constraint))]-10-[v1]-10-[v2(\(constraint))]-20-|", views: leftStackView, titleLabel, rightStackView)
      containerView.addConstraintsToSubviews("V:|[v0]|")
    }
  }

  func set(title: String) {
    self.titleLabel.text = title
  }

  func setIndicatorOffset(xOffset: CGFloat) {
    if collectionView.frame.minX > 0 {
      self.indicatorView.frame = CGRect(x: collectionView.frame.minX + (xOffset * (self.cellSize.width)),
                                        y: self.indicatorView.frame.minY,
                                        width: self.indicatorView.frame.width,
                                        height: self.indicatorView.frame.height)
    }
  }
}

extension CustomNavigationBar: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withClass: NavigationBarCollectionViewCell.self, for: indexPath)
    cell.configureCell(with: items[indexPath.item])
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return cellSize
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    indexChanged?(indexPath)
  }

}
