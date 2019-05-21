//
//  TwinKitModel.swift
//  Twin
//
//  Created by Burak Üstün on 21.09.2018.
//  Copyright © 2018 TWIN. All rights reserved.
//

import UIKit

class TwinKitFirebaseModel {
  var ids:[Int]?
  var name:String?

  public init(ids: [Int]?, name: String?) {
    self.ids = ids
    self.name = name
  }
}

class TwinKitModel: Codable, Equatable {
  var ids: [Int]?
  var name: String?
  var image: String?
  var isSelected: Bool = false

  public class func getModules() -> [TwinKitModel] {
    return getItems(with: "modules")

  }

  public class func getKits() -> [TwinKitModel] {
   return getItems(with: "kits")

  }

  private class func getItems(with key: String) -> [TwinKitModel] {
    guard let resources = ResourceManager.getJson(with: "twins"),
          let modules = resources[key] as? [[String:AnyObject]] else { return []}

    let models = modules.map({TwinKitModel(dictionary: $0)})

    guard let selectedKits = UserDefaults.standard.object(SelectedItems.self, with: "selectedKitsAndModules")?.all else { return models }
    models.forEach({$0.isSelected = selectedKits.contains($0)})
    return models
  }

  convenience init(dictionary: [String:AnyObject]) {
    self.init()
    self.ids = dictionary["ids"] as? [Int]
    self.name = dictionary["name"] as? String
    self.image = dictionary["image"] as? String
  }

  final class func == (lhs: TwinKitModel, rhs: TwinKitModel) -> Bool {
    return lhs.name == rhs.name
  }
}

class SelectedItems: Codable {
  var all: [TwinKitModel]? = []
  var kits: [TwinKitModel]?
  var modules: [TwinKitModel]?

  convenience init(kits: [TwinKitModel]?, modules: [TwinKitModel]?) {
    self.init()
    if let kits = kits {
      self.kits = kits
      all?.append(contentsOf: kits)
    }
    if let modules = modules {
      self.modules = modules
      all?.append(contentsOf: modules)
    }
  }
}
