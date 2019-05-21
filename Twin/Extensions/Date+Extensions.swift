//
//  Date+Extensions.swift
//  Buracutils
//
//  Created by Burak Üstün on 13.09.2018.
//

import Foundation

public extension Date{
  func getString(_ format: String?) -> String? {
    guard let format = format else {
      return nil
    }
    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter.string(from: self)
  }
}

import Foundation

// MARK: - Enums
public extension Date {
  
  ///  Day name format.
  ///
  /// - threeLetters: 3 letter day abbreviation of day name.
  /// - oneLetter: 1 letter day abbreviation of day name.
  /// - full: Full day name.
  enum DayNameStyle {
    /// 3 letter day abbreviation of day name.
    case threeLetters
    
    /// 1 letter day abbreviation of day name.
    case oneLetter
    
    /// Full day name.
    case full
  }
  
  ///  Month name format.
  ///
  /// - threeLetters: 3 letter month abbreviation of month name.
  /// - oneLetter: 1 letter month abbreviation of month name.
  /// - full: Full month name.
  enum MonthNameStyle {
    /// 3 letter month abbreviation of month name.
    case threeLetters
    
    /// 1 letter month abbreviation of month name.
    case oneLetter
    
    /// Full month name.
    case full
  }
  
}

// MARK: - Properties
public extension Date {
  ///  Date string from date.
  ///
  ///     Date().string(withFormat: "dd/MM/yyyy") -> "1/12/17"
  ///     Date().string(withFormat: "HH:mm") -> "23:50"
  ///     Date().string(withFormat: "dd/MM/yyyy HH:mm") -> "1/12/17 23:50"
  ///
  /// - Parameter format: Date format (default is "dd/MM/yyyy").
  /// - Returns: date string.
  func string(withFormat format: String = "dd/MM/yyyy HH:mm") -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: self)
  }
  
}

