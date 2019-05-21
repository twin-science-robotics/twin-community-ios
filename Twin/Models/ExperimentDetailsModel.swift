////
////  ExperimentDetailsModel.swift
////  Twin
////
////  Created by Burak Üstün on 24.09.2018.
////  Copyright © 2018 TWIN. All rights reserved.
////
//
//import Foundation
//import Realm
//import RealmSwift
//
//class ExperimentDetailsModel: Object {
//  @objc dynamic var introduction: Introduction?
//  var tutorials = List<Tutorial>()
//
//  public convenience init(introduction: Introduction?) {
//    self.init()
//    self.introduction = introduction
//  }
//
//  public convenience init(with dict: [String:AnyObject]) {
//    self.init()
//    self.introduction = Introduction(videoImage: dict["videoImage"] as? String,
//                                     chartImage: dict["chartImage"] as? String,
//                                     title: dict["title"] as? String)
//
//    if let tutorialsDict = dict["tutorials"] as? [[String:AnyObject]] {
//      let tutorials = tutorialsDict.map({Tutorial(title: $0["title"] as? String,
//                              desc: $0["desc"] as? String,
//                              image: $0["image"] as? String)})
//    self.tutorials.append(objectsIn: tutorials)
//    }
//  }
//}
//
//class Introduction: Object {
//  @objc dynamic var  videoImage: String?
//  @objc dynamic var  chartImage: String?
//  @objc dynamic var  title: String?
//
//  public convenience init(videoImage: String?, chartImage: String?, title: String?) {
//    self.init()
//    self.videoImage = videoImage
//    self.chartImage = chartImage
//    self.title = title
//  }
//}
//
//class Tutorial: Object {
//  @objc dynamic var  title: String?
//  @objc dynamic var  desc: String?
//  @objc dynamic var  image: String?
//
//  public convenience init(title: String?, desc: String?, image: String?) {
//    self.init()
//    self.title = title
//    self.desc = desc
//    self.image = image
//  }
//}
