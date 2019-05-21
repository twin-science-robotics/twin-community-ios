//
//  ExperimentsModel.swift
//  Twin
//
//  Created by Burak Üstün on 21.09.2018.
//  Copyright © 2018 TWIN. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class ExperimentsResponse: Decodable {
  var experiments:[ExperimentsModel]
}

class ExperimentsModel: Object, Decodable {
  @objc dynamic var image: String?
  @objc dynamic var title: String!
  @objc dynamic var duration: String?
  @objc dynamic var difficulty = 0
  @objc dynamic var experimentID:String!
  @objc dynamic var langCode: String!
  @objc dynamic var chartImage:String?
  @objc dynamic var media:String?
  @objc dynamic var downloadStatus: Bool = false
  var tutorials = List<Tutorial>()
  var requiredIds = List<Int>()
  var isAccessible: Bool = true
    
//  override static func primaryKey() -> String? {
//    return "experimentID"
//  }
  
  private enum CodingKeys: String, CodingKey {
    case imageName, title, duration, difficulty, langCode, requiredIds, chartImage, media, id, tutorials
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    title = try container.decode(String.self, forKey: .title)
    duration = try container.decode(String.self, forKey: .duration)
    difficulty = try container.decode(Int.self, forKey: .difficulty)
    langCode = try container.decode(String.self, forKey: .langCode)
    chartImage = try container.decode(String.self, forKey: .chartImage)
    media = try container.decode(String.self, forKey: .media)
    image = try container.decode(String.self, forKey: .imageName)
    experimentID = try container.decode(String.self, forKey: .id)
    
    let idList = try container.decode([Int].self, forKey: .requiredIds)
    requiredIds.append(objectsIn: idList)

    let tutorialList = try container.decode([Tutorial].self, forKey: .tutorials)
    tutorials.append(objectsIn: tutorialList)
    
    super.init()
  }
  
  required init() {
    super.init()
  }
  
  required init(realm: RLMRealm, schema: RLMObjectSchema) {
    super.init(realm: realm, schema: schema)
//    fatalError("init(realm:schema:) has not been implemented")
  }
  
  required init(value: Any, schema: RLMSchema) {
    fatalError("init(value:schema:) has not been implemented")
  }
}

class Tutorial: Object, Decodable {
  @objc dynamic var  title: String?
  @objc dynamic var  desc: String?
  @objc dynamic var  media: String?

  public convenience init(title: String?, desc: String?, media: String?) {
    self.init()
    self.title = title
    self.desc = desc
    self.media = media
  }
  
  private enum CodingKeys: String, CodingKey {
    case title, desc, media
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    title = try container.decode(String.self, forKey: .title)
    desc = try container.decode(String.self, forKey: .desc)
    media = try container.decode(String.self, forKey: .media)
    super.init()
  }
  
  required init() {
    super.init()
  }
  
  required init(realm: RLMRealm, schema: RLMObjectSchema) {
    super.init(realm: realm, schema: schema)
  }
  
  required init(value: Any, schema: RLMSchema) {
    fatalError("init(value:schema:) has not been implemented")
  }
}

enum Difficulty: Int {
  case easy = 1
  case medium = 2
  case hard = 3
  
  var localized: String {
    switch self {
    case .easy:
      return "Difficulty_Easy".localized
    case .medium:
      return "Difficulty_Medium".localized
    case .hard:
      return "Difficulty_Hard".localized
    }
  }
}
