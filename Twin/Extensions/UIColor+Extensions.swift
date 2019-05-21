//
//  UIColor+Extensions.swift
//  Twin
//
//  Created by Burak Üstün on 18.09.2018.
//  Copyright © 2018 TWIN. All rights reserved.
//

import UIKit

extension UIColor {

  @nonobjc class var aquamarine: UIColor {
    return UIColor(red: 3.0 / 255.0, green: 216.0 / 255.0, blue: 200.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var twilightBlue: UIColor {
    return UIColor(red: 13.0 / 255.0, green: 45.0 / 255.0, blue: 124.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var greyishBrown: UIColor {
    return UIColor(white: 76.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var pinkishGrey: UIColor {
    return UIColor(white: 204.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var veryLightPink: UIColor {
    return UIColor(white: 242.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var yellowishOrange: UIColor {
    return UIColor(red: 1.0, green: 175.0 / 255.0, blue: 16.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var lightblue: UIColor {
    return UIColor(red: 109.0 / 255.0, green: 195.0 / 255.0, blue: 237.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var lightNavyBlue: UIColor {
    return UIColor(red: 41.0 / 255.0, green: 61.0 / 255.0, blue: 124.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var robinSEggBlue: UIColor {
    return UIColor(red: 157.0 / 255.0, green: 252.0 / 255.0, blue: 236.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var teal: UIColor {
    return UIColor(red: 5.0 / 255.0, green: 150.0 / 255.0, blue: 139.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var duckEggBlue: UIColor {
    return UIColor(red: 208.0 / 255.0, green: 239.0 / 255.0, blue: 237.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var salmonPink: UIColor {
    return UIColor(red: 1.0, green: 120.0 / 255.0, blue: 127.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var darkBlueGreen: UIColor {
    return UIColor(red: 0.0, green: 47.0 / 255.0, blue: 43.0 / 255.0, alpha: 1.0)
  }

}

extension UIColor {
  ///   RGB components for a Color (between 0 and 255).
  ///
  ///    UIColor.red.rgbComponents.red -> 255
  ///    NSColor.green.rgbComponents.green -> 255
  ///    UIColor.blue.rgbComponents.blue -> 255
  ///
  public var rgbComponents: (red: Int, green: Int, blue: Int) {
    var components: [CGFloat] {
      let comps = cgColor.components!
      if comps.count == 4 { return comps }
      return [comps[0], comps[0], comps[0], comps[1]]
    }
    let red = components[0]
    let green = components[1]
    let blue = components[2]
    return (red: Int(red * 255.0), green: Int(green * 255.0), blue: Int(blue * 255.0))
  }

  ///   RGB components for a Color represented as CGFloat numbers (between 0 and 1)
  ///
  ///    UIColor.red.rgbComponents.red -> 1.0
  ///    NSColor.green.rgbComponents.green -> 1.0
  ///    UIColor.blue.rgbComponents.blue -> 1.0
  ///
  public var cgFloatComponents: (red: CGFloat, green: CGFloat, blue: CGFloat) {
    var components: [CGFloat] {
      let comps = cgColor.components!
      if comps.count == 4 { return comps }
      return [comps[0], comps[0], comps[0], comps[1]]
    }
    let red = components[0]
    let green = components[1]
    let blue = components[2]
    return (red: red, green: green, blue: blue)
  }

  ///   Get components of hue, saturation, and brightness, and alpha (read-only).
  public var hsbaComponents: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
    var hue: CGFloat = 0.0
    var saturation: CGFloat = 0.0
    var brightness: CGFloat = 0.0
    var alpha: CGFloat = 0.0

    getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
    return (hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
  }

  ///   Hexadecimal value string (read-only).
  public var hexString: String {
    let components: [Int] = {
      let comps = cgColor.components!
      let components = comps.count == 4 ? comps : [comps[0], comps[0], comps[0], comps[1]]
      return components.map { Int($0 * 255.0) }
    }()
    return String(format: "#%02X%02X%02X", components[0], components[1], components[2])
  }

  ///   Short hexadecimal value string (read-only, if applicable).
  public var shortHexString: String? {
    let string = hexString.replacingOccurrences(of: "#", with: "")
    let chrs = Array(string)
    guard chrs[0] == chrs[1], chrs[2] == chrs[3], chrs[4] == chrs[5] else { return nil }
    return "#\(chrs[0])\(chrs[2])\(chrs[4])"
  }

  ///   Short hexadecimal value string, or full hexadecimal string if not possible (read-only).
  public var shortHexOrHexString: String {
    let components: [Int] = {
      let comps = cgColor.components!
      let components = comps.count == 4 ? comps : [comps[0], comps[0], comps[0], comps[1]]
      return components.map { Int($0 * 255.0) }
    }()
    let hexString = String(format: "#%02X%02X%02X", components[0], components[1], components[2])
    let string = hexString.replacingOccurrences(of: "#", with: "")
    let chrs = Array(string)
    guard chrs[0] == chrs[1], chrs[2] == chrs[3], chrs[4] == chrs[5] else { return hexString }
    return "#\(chrs[0])\(chrs[2])\(chrs[4])"
  }
}

extension UIColor {
    ///   Create Color from hexadecimal string with optional transparency (if applicable).
    ///
    /// - Parameters:
    ///   - hexString: hexadecimal string (examples: EDE7F6, 0xEDE7F6, #EDE7F6, #0ff, 0xF0F, ..).
    ///   - transparency: optional transparency value (default is 1).
    public convenience init?(hexString: String, transparency: CGFloat = 1) {
      var string = ""
      if hexString.lowercased().hasPrefix("0x") {
        string =  hexString.replacingOccurrences(of: "0x", with: "")
      } else if hexString.hasPrefix("#") {
        string = hexString.replacingOccurrences(of: "#", with: "")
      } else {
        string = hexString
      }

      if string.count == 3 { // convert hex to 6 digit format if in short format
        var str = ""
        string.forEach { str.append(String(repeating: String($0), count: 2)) }
        string = str
      }

      guard let hexValue = Int(string, radix: 16) else { return nil }

      var trans = transparency
      if trans < 0 { trans = 0 }
      if trans > 1 { trans = 1 }

      let red = (hexValue >> 16) & 0xff
      let green = (hexValue >> 8) & 0xff
      let blue = hexValue & 0xff
      self.init(red: red, green: green, blue: blue, transparency: trans)
    }

    ///   Create Color from RGB values with optional transparency.
    ///
    /// - Parameters:
    ///   - red: red component.
    ///   - green: green component.
    ///   - blue: blue component.
    ///   - transparency: optional transparency value (default is 1).
    public convenience init?(red: Int, green: Int, blue: Int, transparency: CGFloat = 1) {
      guard red >= 0 && red <= 255 else { return nil }
      guard green >= 0 && green <= 255 else { return nil }
      guard blue >= 0 && blue <= 255 else { return nil }

      var trans = transparency
      if trans < 0 { trans = 0 }
      if trans > 1 { trans = 1 }

      self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: trans)
    }
}
