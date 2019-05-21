//
//  SignUpFields.swift
//  Twin
//
//  Created by Burak Üstün on 10.10.2018.
//  Copyright © 2018 TWIN. All rights reserved.
//

import UIKit

enum SignUpFields {
  case nameSurname, email, phoneNumber, password, city, age

  static let allValues = [nameSurname, email, phoneNumber, password, city, age]

  var title: String {
    switch self {
    case .nameSurname:
      return "SignUpViewController_NameSurname".localized
    case .email:
      return "SignUpViewController_Email".localized
    case .phoneNumber:
      return "SignUpViewController_Phone".localized
    case .password:
      return "SignUpViewController_Password".localized
    case .city:
      return "SignUpViewController_City".localized
    case .age:
      return "SignUpViewController_Age".localized
    }
  }

  var keyboardType: UIKeyboardType {
    switch self {
    case .nameSurname:
      return .asciiCapable
    case .email:
      return .emailAddress
    case .phoneNumber:
      return .numbersAndPunctuation
    case .password:
      return .asciiCapable
    case .city:
      return .asciiCapable
    case .age:
      return .numberPad
    }
  }

  var contentType: UITextContentType {
    switch self {
    case .nameSurname:
      return .name
    case .email:
      return .emailAddress
    case .phoneNumber:
      return .telephoneNumber
    case .password:
      if #available(iOS 12, *) {
        // iOS 12: Not the best solution, but it works.
        return .oneTimeCode
      } else {
        // iOS 11: Disables the autofill accessory view.
        return .init(rawValue: "")
      }
    case .city:
      return .addressCity
    case .age:
      return .init(rawValue: "age")
    }
  }

  var isRequired: Bool {
    switch self {
    case .email, .password:
      return true
    default:
      return false
    }
  }

  var errorMessage: String? {
    switch self {
    case .email:
      return "SignUpViewController_Warning_Email".localized
    case .password:
      return "SignUpViewController_Warning_Password".localized
    default:
      return nil
    }
  }
  
  var autoCapilazitionType: UITextAutocapitalizationType {
    switch self {
    case .nameSurname, .city:
      return .words
    default:
      return .none
    }
  }

  var cellId: String {
    return String(describing: self)
  }

}
