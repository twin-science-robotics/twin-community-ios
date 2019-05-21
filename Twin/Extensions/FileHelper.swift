/*
 * Copyright 2017 Google Inc. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation

/**
 Helper for loading and saving files to the user document directory.
 */
@objc @objcMembers class FileHelper: NSObject {
  /**
   Loads the contents of a given file.
   
   - parameter file: The location of the file in the user's document directory.
   - returns: If the file was found, the contents of the file. If not, then `nil`.
   */
  public static func loadContents(of file: String) -> String? {
    let documentDirectory =
      NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    if let url = NSURL(fileURLWithPath: documentDirectory).appendingPathComponent(file) {
      if FileManager.default.fileExists(atPath: url.path) {
        do {
          return try String(contentsOf: url, encoding: .utf8)
        } catch let error {
          print("Couldn't load file \(file): \(error)")
        }
      }
    }

    return nil
  }

  public static func loadFromBundle(of file: String) -> String? {
    if let url = Bundle.main.url(forResource: file, withExtension: nil) {
      return try? String(contentsOf: url, encoding: .utf8)
    }
    return nil
  }

  /**
   Saves contents to a given file. Any previous content is overwritten if it existed before.
   
   - parameter file: The save location in the user's document directory.
   */
  public static func saveContents(_ contents: String, to file: String) {
    let documentDirectory =
      NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

    if let url = NSURL(fileURLWithPath: documentDirectory).appendingPathComponent(file) {
      // Create directories first
      do {
        let directory = url.deletingLastPathComponent()
        try FileManager.default.createDirectory(
          atPath: directory.path, withIntermediateDirectories: true, attributes: nil)
      } catch let error {
        print("Couldn't create directory: \(error)")
      }

      // Write to file
      do {
        try contents.write(to: url, atomically: false, encoding: .utf8)
      } catch let error {
        print("Couldn't save file \(file): \(error)")
      }
    }
  }

  public static func checkDifference(_ contents: String, to file: String) -> Bool {
    let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    if let url = NSURL(fileURLWithPath: documentDirectory).appendingPathComponent(file) {
      if FileManager.default.fileExists(atPath: url.path) {
        do {
          guard let tempUrl = NSURL(fileURLWithPath: documentDirectory).appendingPathComponent("temp.xml") else { return false }
          do {
            let directory = tempUrl.deletingLastPathComponent()
            try FileManager.default.createDirectory(
              atPath: directory.path, withIntermediateDirectories: true, attributes: nil)
          } catch let error {
            print("Couldn't create directory: \(error)")
          }
          try contents.write(to: tempUrl, atomically: false, encoding: .utf8)

          let tempString = try String(contentsOf: tempUrl, encoding: .utf8)
          let savedString = try String(contentsOf: url, encoding: .utf8)

          return savedString == tempString
        } catch let error {
          print("Couldn't load file \(file): \(error)")
          return false
        }
      }
    }
    return contents == "<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>\n<xml xmlns=\"http://www.w3.org/1999/xhtml\" />"
  }
}
