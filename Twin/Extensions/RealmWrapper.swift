//
//  RealmWrapper.swift
//  Twin
//
//  Created by Burak Üstün on 10.10.2018.
//  Copyright © 2018 TWIN. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class RealmWrapper {

  static let shared = RealmWrapper()

  let realm: Realm!

  private init() {
    let configuration = Realm.Configuration(schemaVersion: 5, migrationBlock: { _, _ in //migration, oldSchemaVersion in
        //if oldSchemaVersion < 1 {
//          // if just the name of your model's property changed you can do this
//          migration.renameProperty(onType: NotSureItem.className(), from: "text", to: "title")
//
//          // if you want to fill a new property with some values you have to enumerate
//          // the existing objects and set the new value
//          migration.enumerateObjects(ofType: NotSureItem.className()) { oldObject, newObject in
//            let text = oldObject!["text"] as! String
//            newObject!["textDescription"] = "The title is \(text)"
//          }
//
//          // if you added a new property or removed a property you don't
//          // have to do anything because Realm automatically detects that
     //   }
    })
    Realm.Configuration.defaultConfiguration = configuration
    realm = try! Realm()
  }
  
  public func deleteExperiments() {
    let experiments = RealmWrapper.shared.objects(ExperimentsModel.self, filter: NSPredicate(format: "langCode == %@", Language.language.rawValue))
    experiments.forEach({RealmWrapper.shared.delete(object: $0)})
  }
  
  public func deleteProjects() {
    let projects = RealmWrapper.shared.objects(ProjectModel.self, filter: NSPredicate(format: "isMine == false"))
    projects.forEach({RealmWrapper.shared.delete(object: $0)})
    
  }

  public func objects<Element: Object>(_ type: Element.Type, filter: NSPredicate? = nil) -> Results<Element> {
    guard let filter = filter else {
      return realm.objects(type)
    }
    return realm.objects(type).filter(filter)
  }

  public func object<Element: Object>(ofType type: Element.Type, forPrimaryKey key: String) -> Element? {
    return realm.object(ofType: type, forPrimaryKey: key)
  }

  public func delete(object: Object?) {
    guard let object = object else { return }
    try? realm.write {
      realm.delete(object)
    }
  }

  public func add(object: Object) {
    try? realm.write {
      realm.add(object)
    }
  }

  public func add(object: [Object]) {
    try? realm.write {
      realm.add(object)
    }
  }
  
  public func update(name: String, projectId: String) {
    guard let project = objects(ProjectModel.self, filter: NSPredicate(format: "projectID == %@", projectId)).first else { return }
    try? realm.write {
      project.title = name
    }
  }
  
  public func update(_ id:String, downloadStatus: Bool) {
    guard let experiment = objects(ExperimentsModel.self, filter: NSPredicate(format: "experimentID == %@", id)).first else { return }
    try? realm.write {
      experiment.downloadStatus = downloadStatus
    }
  }

}
