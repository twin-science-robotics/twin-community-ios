//
//  MyProjectsTableViewCell.swift
//  Twin
//
//  Created by Burak Üstün on 20.09.2018.
//  Copyright © 2018 TWIN. All rights reserved.
//

import UIKit

class MyProjectsTableViewCell: UICollectionViewCell {

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
    return NSPredicate(format: "isMine == true")
  }
  lazy var arrayProjects: [ProjectModel] = Array(RealmWrapper.shared.objects(ProjectModel.self, filter: filter)).reversed()

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

  func refresh(_ projectId: String?) {
    if let projectId = projectId {
      RealmWrapper.shared.delete(object: RealmWrapper.shared.objects(ProjectModel.self,
                                                                     filter: NSPredicate(format: "projectID == %@", projectId)).first)
    }
    self.arrayProjects = Array(RealmWrapper.shared.objects(ProjectModel.self, filter: NSPredicate(format: "isMine == true"))).reversed()
    self.collectionView.reloadData()
  }

  func updateCollectionView(id: String) {
    guard let index = findIndexPath(id) else { return}
    print(index)
    self.collectionView.performBatchUpdates({
      self.collectionView.deleteItems(at: [IndexPath(row: index)])
    }, completion: nil)
  }

  private func findIndexPath(_ projectId: String) -> Int? {
    for (index, item) in self.arrayProjects.enumerated() where item.projectID == projectId {
        return index + 1
    }
    return nil
  }

}

extension MyProjectsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return arrayProjects.count + 1
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if indexPath.item == 0 {
      let cell = collectionView.dequeueReusableCell(withClass: AddNewProjectCollectionViewCell.self, for: indexPath)
      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(withClass: ProjectsCollectionViewCell.self, for: indexPath)
      cell.configureCell(model: arrayProjects[indexPath.item - 1])
      cell.topView.backgroundColor = UIColor(hexString: Utils.shared.projectColors[indexPath.row % Utils.shared.projectColors.count])
      cell.parent = self
      return cell
    }

  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let projectId = indexPath.item == 0 ? UUID().uuidString : arrayProjects[indexPath.item - 1].projectID 
    let destination =  BlocklyViewController(projectId: projectId)
    parent?.navigationController?.show(destination, sender: self)
  }

}

extension MyProjectsTableViewCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = ((collectionView.frame.width) / 3)
    let size = CGSize(width: width, height: width + 50)
    return size
  }
}
