//
//  TwinModel.swift
//  Twin
//
//  Created by Burak Üstün on 10.10.2018.
//  Copyright © 2018 TWIN. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class TwinUser: Object {
  @objc dynamic var name: String?
  @objc dynamic var phoneNumber: String?
  @objc dynamic var city: String?
  @objc dynamic var age: String?
  @objc dynamic var id: String?
  @objc dynamic var email: String?

  convenience init(with dict: NSDictionary, id: String) {
    self.init()
    name = dict["name"] as? String
    phoneNumber = dict["phoneNumber"] as? String
    city = dict["city"] as? String
    age = dict["age"] as? String
    email = dict["mail"] as? String
    self.id = id
  }
}
