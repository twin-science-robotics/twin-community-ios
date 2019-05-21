//
//  IndexPath+Extensions.swift
//  Buracutils
//
//  Created by Burak Üstün on 13.09.2018.
//

import Foundation

public extension IndexPath {
  init(row: Int) {
    self.init(row: row, section: 0)
  }
}
