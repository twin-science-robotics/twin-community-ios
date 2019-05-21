//
//  ResouceManager.swift
//  Twin
//
//  Created by Burak Üstün on 8.03.2019.
//  Copyright © 2019 TWIN. All rights reserved.
//

import Foundation

class ResourceManager {
  class func loadResources() {
    let targetVersion = 3
    if (UserDefaults.standard.value(forKey: "kResourceVersion") as? Int) ?? 0 < targetVersion {
      RealmWrapper.shared.deleteProjects()
//      getExperiments()
      getProjects()
      UserDefaults.standard.set(targetVersion, forKey: "kResourceVersion")
    }
    
  }

  private class func getProjects() {
    guard let projectsDict = getJson(with: "Projects") else { return }
    let projects = ProjectModel.getAllProjects(with: projectsDict)
    RealmWrapper.shared.add(object: projects)
  }

  class func getJson(with resourceName:String) -> [String:AnyObject]? {
    guard let path = Bundle.main.path(forResource: resourceName, ofType: "json"),
      let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
      let result = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
        return nil
    }
    return result as? [String:AnyObject]
  }
}
