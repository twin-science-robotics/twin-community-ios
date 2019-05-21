//
//  Router.swift
//  Twin
//
//  Created by Burak Üstün on 20.09.2018.
//  Copyright © 2018 TWIN. All rights reserved.
//

import Foundation

class Router {
  
//  static weak var bluetoothService:CoreBluetoothService?
  static weak var blocklyViewController:BlocklyViewController?
  
  static var bluetoothService:CoreBluetoothService? {
    return Router.blocklyViewController?.bluetoothService
  }
}
