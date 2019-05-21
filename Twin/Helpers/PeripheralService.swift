//
//  BluetoothService.swift
//  Twin
//
//  Created by Burak Üstün on 15.10.2018.
//  Copyright © 2018 TWIN. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol PeripheralServiceDelegate: class {
  func deviceConnected()
}

class PeripheralService: NSObject {

  var didUpdatedValue: (([UInt8]) -> Void)?
  var onDeviceConnect: (() -> Void)?
  var peripheral: CBPeripheral?
  var positionCharUUID:CBUUID?
  weak var delegate: PeripheralServiceDelegate?

  var characteristics: CBCharacteristic? {
    didSet {
      if let positionCharacteristic = characteristics {
        logger.debug("Characterictics Set")
        NotificationCenter.default.post(Notification(name: .twinConnected))
        Router.bluetoothService?.currentPeripheral?.readValue(for: positionCharacteristic)
        Router.bluetoothService?.currentPeripheral?.setNotifyValue(true, for: positionCharacteristic)
      }
    }
  }

  init(with peripheral: CBPeripheral, uuid: CBUUID) {
    super.init()
    self.peripheral = peripheral
    self.peripheral?.delegate = self
    self.positionCharUUID = uuid
    startDiscoveringServices()
  }
  
  deinit {
    self.reset()
  }

  func startDiscoveringServices() {
    self.peripheral?.discoverServices(nil)
  }

  func reset() {
    peripheral = nil
  }
  
}

  extension PeripheralService: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
      if (peripheral != self.peripheral) || (error != nil) || (peripheral.services == nil) || (peripheral.services!.count == 0) {
        return
      }
      peripheral.services?.forEach({peripheral.discoverCharacteristics(nil, for: $0)})
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
      if (peripheral != self.peripheral) || (error != nil) {
        return
      }
      characteristics = service.characteristics?.filter({$0.uuid == positionCharUUID}).first
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
      Router.bluetoothService?.currentPeripheral?.readValue(for: characteristic)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
      guard let value = characteristic.value else { return }
      let array = [UInt8](value)
      didUpdatedValue?(array)
    }
    
  }
  
extension PeripheralService {
  func write(_ uInt8textArray: String) {
    DispatchQueue.global(qos: .userInitiated).async {
      guard let positionCharacteristic = self.characteristics else { return }
      var uIntArray: [UInt8] = []
      uInt8textArray.split(separator: "-").forEach({
        guard let uIntItem = UInt8($0, radix: 16) else {
          logger.error("Couldn't parse uInt8textArray")
          return
        }
        uIntArray.append(uIntItem)
      })
      
      /// Whether to write to the HM10 with or without response. Set automatically.
      /// Legit HM10 modules (from JNHuaMao) require 'Write without Response',
      /// while fake modules (e.g. from Bolutek) require 'Write with Response'.
      // https://github.com/hoiberg/HM10-BluetoothSerial-iOS/blob/master/HM10%20Serial/BluetoothSerial.swift
      
      let writeType: CBCharacteristicWriteType = positionCharacteristic.properties.contains(.write) ? .withResponse : .withoutResponse
      self.peripheral?.writeValue(Data(uIntArray), for: positionCharacteristic, type: writeType)
    }
    
  }

}
