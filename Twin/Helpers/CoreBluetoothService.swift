//
//  BluetoothHelper.swift
//  Twin
//
//  Created by Burak Üstün on 28.09.2018.
//  Copyright © 2018 TWIN. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol CoreBluetoothServiceDelegate: class {
  func isDeviceConnected(_ status: Bool)
}

class CoreBluetoothService: NSObject {

  private var BLEServiceUUID = CBUUID(string: "FFE0")
  private var positionCharUUID = CBUUID(string: "FFE1")
  private var peripheralArray:[TwinPeripheral] = []
  fileprivate var lastUpdateDate = Date()
  fileprivate var dateString: String {
    return String(Int(lastUpdateDate.timeIntervalSince1970.rounded(.up)))
  }
  override init() {
    super.init()
    initializeCentralManager()
  }
  
  deinit {
    logger.info("deinit")
  }
  
  convenience init(_ serviceUUID:String, _ characteristicsUUID: String) {
    self.init()
    self.BLEServiceUUID = CBUUID(string: serviceUUID)
    self.positionCharUUID = CBUUID(string: characteristicsUUID)
  }
  
  var bluetoothManager: CBCentralManager?
  var currentPeripheral: CBPeripheral?
  var peripheralService: PeripheralService?
  
  private func initializeCentralManager() {
    let centralQueue = DispatchQueue(label: "tr.com.twin.ios", attributes: [])
    bluetoothManager = CBCentralManager(delegate: self, queue: centralQueue, options: [CBCentralManagerOptionShowPowerAlertKey:false])
  }
  
  func startScanning() {
    bluetoothManager?.scanForPeripherals(withServices: [BLEServiceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
    lastUpdateDate = Date()
    peripheralArray = []
    self.perform(#selector(handleTimeOut), with: nil, afterDelay: 3.1)
    DispatchQueue.main.async {
      PopupManager.standart.show(type: .regular, title: "TwinDiscovery_SearchingTwins".localized, yes: "Global_Cancel".localized, nil, onCancel: {
        self.clearDevices()
      })
    }
  }
  
  func clearDevices() {
    DispatchQueue.global(qos: .userInitiated).async {
      self.bluetoothManager?.cancelPeripheralConnection(self.currentPeripheral)
      self.bluetoothManager?.stopScan()
      self.peripheralService = nil
      self.currentPeripheral = nil
    }
  }
  
  func choosePeripheral() -> CBPeripheral? {
    let dictionary = Dictionary(grouping: peripheralArray, by: {$0.peripheral})
    let mappedArray = dictionary.map({TwinPeripheral(peripheral: $0.key,
                                                     rssiValue: $0.value.map({$0.rssiValue}).reduce(0, +)/Double($0.value.count))})
    return mappedArray.sorted(by: {$0.rssiValue > $1.rssiValue}).first?.peripheral
  }
  
  @objc func handleTimeOut() {
    guard peripheralArray.isEmpty else { return }
    DispatchQueue.main.async {
      PopupManager.standart.dismiss {
        PopupManager.standart.show(type: .regular, title: "BlocklyViewController_TimeOut".localized, nil, onCancel: nil)
      }
    }
  }
  
}

extension CoreBluetoothService: CBCentralManagerDelegate {
  
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    switch central.state {
    case .poweredOff:
      logger.debug("Powered Off")
      DispatchQueue.main.async {
        PopupManager.standart.show(type: .regular, title: "TwinDiscovery_Error_Bluetooth".localized, nil, onCancel: nil)
      }
      clearDevices()
    case .resetting:
      logger.debug("Resetting")
      clearDevices()
    default:
      break
    }
  }
  
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
    guard peripheral.name == "Twin" || peripheral.name == "BT05", currentPeripheral == nil else { return }
    if lastUpdateDate.timeIntervalSinceNow > -3 {
      peripheralService = nil
      peripheralArray.append(TwinPeripheral(peripheral: peripheral, rssiValue: Double(RSSI.intValue)))
    } else {
      guard let selectedPeripheral = choosePeripheral() else {
        central.stopScan()
        return
      }
      currentPeripheral = selectedPeripheral
      central.connect(selectedPeripheral, options: nil)
    }
  }
  
  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    guard peripheral == currentPeripheral else { return }
    peripheralService = PeripheralService(with: peripheral, uuid: positionCharUUID)
    central.stopScan()
  }
  
  func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    clearDevices()
    NotificationCenter.default.post(Notification(name: .twinDisconnected))
  }
  
  func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
  }
  
}

extension CBCentralManager {
  func cancelPeripheralConnection(_ peripheral: CBPeripheral?) {
    guard let peripheral = peripheral else { return }
    cancelPeripheralConnection(peripheral)
  }
}

class TwinPeripheral {
  var peripheral:CBPeripheral
  var rssiValue:Double
  
  public init(peripheral: CBPeripheral, rssiValue: Double) {
    self.peripheral = peripheral
    self.rssiValue = rssiValue
  }
}
