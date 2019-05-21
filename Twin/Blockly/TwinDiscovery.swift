//
//  BluetoothHelper.swift
//  Twin
//
//  Created by Burak Üstün on 28.09.2018.
//  Copyright © 2018 YGA. All rights reserved.
//

import Foundation
import CoreBluetooth

let BLEServiceUUID = CBUUID(string: "FFE0")
let positionCharUUID = CBUUID(string: "FFE1")

class CoreBluetoothService: NSObject {
  var didShowSuccessPopup = false
  
  override init() {
    super.init()
    let centralQueue = DispatchQueue(label: "tr.org.yga.twin.ios", attributes: [])
    centralManager = CBCentralManager(delegate: self, queue: centralQueue)
  }
//  static let shared = TwinDiscovery()
  fileprivate var centralManager: CBCentralManager?

  var peripheralBLE: CBPeripheral?

  var peripheralService: PeripheralService? {
    didSet {
      peripheralService?.startDiscoveringServices()
    }
  }

  func startScanning() {
    guard let central = centralManager else { return }
    central.scanForPeripherals(withServices: [BLEServiceUUID], options: nil)
    DispatchQueue.main.async {
      self.didShowSuccessPopup = false
      PopupManager.standart.show(type: .regular, title: "TwinDiscovery_SearchingTwins".localized, yes: "Global_Cancel".localized, nil, onCancel: {
        DispatchQueue.global(qos: .background).async {
          self.clearDevices()
        }
      })
      //        PopupManager.standart.animateSearchingText()
    }
  }

  func clearDevices() {
    centralManager?.stopScan()
    if let ble = peripheralBLE {
      self.centralManager?.cancelPeripheralConnection(ble)
    }
    peripheralService = nil
    peripheralBLE = nil
  }
}

extension CoreBluetoothService: CBCentralManagerDelegate {

  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    switch central.state {
    case .poweredOn:
      break
    case .poweredOff:
       DispatchQueue.main.async {
        PopupManager.standart.show(type: .regular, title: "TwinDiscovery_Error_Bluetooth".localized, nil, onCancel: nil)
       }
        DispatchQueue.global(qos: .background).async {
          self.clearDevices()
        }
    case .resetting:
      DispatchQueue.global(qos: .background).async {
        self.clearDevices()
      }
    default:
      print("centralManagerDidUpdateState Default")
    }
  }

  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
    guard peripheral.name != nil, peripheral.name != "" else {
      return
    }

    if peripheral.name == "Twin" || peripheral.name == "BT05" && (peripheralBLE == nil) {
        peripheralBLE = peripheral
        peripheralService = nil
        central.connect(peripheral, options: nil)
    }
  }

  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    if peripheral == peripheralBLE {
      peripheralService = PeripheralService(initWithPeripheral: peripheral)
    }
    central.stopScan()
  }

  func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    DispatchQueue.global(qos: .background).async {
      self.clearDevices()
      NotificationCenter.default.post(Notification(name: .twinDisconnected))
    }
    
  }
  
}
