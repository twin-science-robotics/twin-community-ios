//
//  ProjectsViewController.swift
//  Twin
//
//  Created by Burak Üstün on 20.09.2018.
//  Copyright © 2018 TWIN. All rights reserved.
//

import UIKit

class ProjectsViewController: BaseUIViewController {
  
  let layout = UICollectionViewFlowLayout().with({
    $0.scrollDirection = .horizontal
    $0.minimumLineSpacing = 0
    $0.minimumInteritemSpacing = 0
  })
  
  lazy var collectionView: UICollectionView = {
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.delegate = self
    cv.dataSource = self
    cv.register(cellWithClass: TwinProjectsCollectionViewCell.self)
    cv.register(cellWithClass: MyProjectsTableViewCell.self)
    cv.backgroundColor = .clear
    cv.isPagingEnabled = true
    cv.bounces = false
    cv.contentInset = .zero
    cv.showsHorizontalScrollIndicator = false
    return cv
  }()

  let sliderItems: [String] = ["ProjectsViewController_Samples".localized,
                               "ProjectsViewController_MyProjects".localized]

  override func viewDidLoad() {
    super.viewDidLoad()
    let twinButton = UIButton(style: Stylesheet.Button.twin)
    buildController(settings: .onlyNavigationBar, sliderItems: sliderItems, leftItems: [twinButton])
    setBackground(color: .veryLightPink)
    configureViews()
    setBindings()
    navigationBar?.controller = self
    if #available(iOS 11.0, *) {
      collectionView.contentInsetAdjustmentBehavior = .never
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    guard let myProjectsCell = collectionView.cellForItem(at: IndexPath(row: 1)) as? MyProjectsTableViewCell else {
      return
    }
    myProjectsCell.refresh(nil)
  }

  func configureViews() {
    contentView.addSubview(collectionView)
    contentView.addConstraints("V:|[v0]|", views: collectionView)
    contentView.addConstraints("H:|-10-[v0]-10-|", views: collectionView)
    collectionView.reloadData()
  }

  func setBindings() {
    navigationBar?.indexChanged = { indexPath in
      self.collectionView.scrollToItem(at: indexPath, at: [], animated: true)
    }
  }

  @objc func back() {
    self.navigationController?.popViewController(animated: true)
  }

  func refresh() {

  }
}

extension ProjectsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return sliderItems.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if indexPath.item == 0 {
      let cell = collectionView.dequeueReusableCell(withClass: TwinProjectsCollectionViewCell.self, for: indexPath)
      cell.parent = self
      return cell
    }
    let cell = collectionView.dequeueReusableCell(withClass: MyProjectsTableViewCell.self, for: indexPath)
    cell.parent = self
    return cell
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let result = Utils.normalization(width: contentView.frame.size.width, offSet: scrollView.contentOffset.x)
    navigationBar?.setIndicatorOffset(xOffset: result)
  }

  func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                 withVelocity velocity: CGPoint,
                                 targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    if scrollView == collectionView {
      let index = targetContentOffset.pointee.x / collectionView.frame.width
      let indexPath = IndexPath(item: Int(index), section: 0)
      navigationBar?.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])

    }
  }
}

extension ProjectsViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: contentView.frame.width - 20, height: contentView.frame.height)
  }
}
