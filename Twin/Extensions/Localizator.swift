//
//  Localizator.swift
//
//  Created by Burak Üstün on 26.10.2018.
//  Copyright © 2018 TWIN. All rights reserved.
//

import Foundation

private class Localizator {

  static let shared = Localizator()
  
  var localizableDictionary:NSDictionary! {
    if let path = Bundle.main.path(forResource: Language.language.rawValue, ofType: "lproj") {
      let bundle = Bundle(path: path)
      if let dictPath = bundle?.path(forResource: "Localizable", ofType: "plist") {
        return NSDictionary(contentsOfFile: dictPath)
      }
    }
    fatalError("Localizable file NOT found")
  }

  func localize(string: String) -> String {
    guard let localizedString = localizableDictionary.value(forKey: string) as? String else {
      assertionFailure("Missing translation for: \(string)")
      return ""

    }
    return localizedString
  }
}

extension String {
  var localized: String {
    return Localizator.shared.localize(string: self)
  }
}

private let appleLanguagesKey = "AppleLanguages"

enum Language: String {
  case turkish = "tr"
  case english  = "en"
  case none
  
  static var language: Language {
    get {
      if let languageCode = (UserDefaults.standard.object(forKey: appleLanguagesKey) as? [String])?.first,
        let language = Language(rawValue: languageCode) {
        return language
      } else {
        let preferredLanguage = NSLocale.preferredLanguages[0] as String
        let index = preferredLanguage.index(preferredLanguage.startIndex, offsetBy: 2)
        guard let localization = Language(rawValue: String(preferredLanguage.prefix(upTo: index))) else {
          return Language.english
        }
        
        return localization
      }
    }
    set {
      guard language != newValue else {
        return
      }
      
      UserDefaults.standard.set([newValue.rawValue], forKey: appleLanguagesKey)
      UserDefaults.standard.synchronize()

    }
  }
}
