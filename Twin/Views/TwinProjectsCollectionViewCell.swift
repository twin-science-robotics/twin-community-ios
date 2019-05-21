//
//  TwinProjectsCollectionViewCell.swift
//  Twin
//
//  Created by Burak Üstün on 20.09.2018.
//  Copyright © 2018 TWIN. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class TwinProjectsCollectionViewCell: UICollectionViewCell {

  weak var parent: ProjectsViewController?

  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.delegate = self
    cv.dataSource = self
    cv.register(cellWithClass: ProjectsCollectionViewCell.self)
    cv.register(cellWithClass: AddNewProjectCollectionViewCell.self)
    cv.backgroundColor = .clear
    cv.showsVerticalScrollIndicator = false
    return cv
  }()

  var filter:NSPredicate {
    return NSPredicate(format: "isMine == false AND langCode = %@", Language.language.rawValue)
  }
  lazy var arrayProjects = RealmWrapper.shared.objects(ProjectModel.self, filter: filter)

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureViews()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configureViews() {
    addSubview(collectionView)
    addConstraints("V:|[v0]|", views: collectionView)
    addConstraints("H:|[v0]|", views: collectionView)
    collectionView.reloadData()
  }
}

extension TwinProjectsCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return arrayProjects.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withClass: ProjectsCollectionViewCell.self, for: indexPath)
    cell.configureCell(model: arrayProjects[indexPath.item])
    cell.topView.backgroundColor = UIColor(hexString: Utils.shared.projectColors[indexPath.row % Utils.shared.projectColors.count])
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = ((collectionView.frame.width) / 3)
    let size = CGSize(width: width, height: width + 50)
    return size
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let item = arrayProjects[indexPath.item]
    let destination =  BlocklyViewController(item.projectID,
                                             defaultPath: arrayProjects[indexPath.item].projectID)
      parent?.navigationController?.show(destination, sender: self)
  }

}
