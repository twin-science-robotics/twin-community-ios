//
//  ProjectModel.swift
//  Twin
//
//  Created by Burak Üstün on 20.09.2018.
//  Copyright © 2018 TWIN. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class ProjectModel: Object {
  
  @objc dynamic var projectID = UUID().uuidString
  @objc dynamic var image: String!
  @objc dynamic var title: String!
  @objc dynamic var topBackgroundColor: String?
  @objc dynamic var isMine: Bool = false
  @objc dynamic var dateString: String!
  @objc dynamic var langCode: String!
  
  convenience init(_ projectID: String? = nil,
                   image: String! = "mockProjectImage",
                   title: String!,
                   topBackgroundColor: UIColor = .white,
                   isMine: Bool = false,
                   dateString: String! = Date().string(withFormat: "dd.MM.yyyy"),
                   langCode: Language = .none) {
    self.init()
    self.image = image
    self.title = title
    self.topBackgroundColor = topBackgroundColor.hexString
    self.isMine = isMine
    self.dateString = dateString
    self.langCode = langCode.rawValue
    if let projectId = projectID {
      self.projectID = projectId
    }
  }
  
  class func getAllProjects(with dictionary: [String:AnyObject]) -> [ProjectModel] {
    guard let projects = dictionary["projects"] as? [[String:AnyObject]] else { return [] }
    return projects.map({ProjectModel(with: $0)})
  }
  
  convenience init(with dictionary: [String:AnyObject]) {
    self.init()
    if let id = dictionary["id"] as? String {
      self.projectID = id
    }
    if let image = dictionary["image"] as? String {
      self.image = image
    }
    if let title = dictionary["title"] as? String {
      self.title = title
    }
    if let hexColor = dictionary["backgroundColor"] as? String {
      self.topBackgroundColor = hexColor
    }
    if let langCode = dictionary["langCode"] as? String {
      self.langCode = langCode
    }
    if let dateString = dictionary["date"] as? String {
      self.dateString = dateString
    }
    
  }
}
