//
//  BluetoothService.swift
//  Twin
//
//  Created by Burak Üstün on 15.10.2018.
//  Copyright © 2018 YGA. All rights reserved.
//

import Foundation
import CoreBluetooth

class PeripheralService: NSObject {

  var didUpdatedValue: (([UInt8]) -> Void)?

  var peripheral: CBPeripheral?

  var characteristics: CBCharacteristic? {
    didSet {
      if let positionCharacteristic = characteristics {
        NotificationCenter.default.post(Notification(name: .twinConnected))
        Router.bluetoothService?.peripheralBLE?.readValue(for: positionCharacteristic)
        Router.bluetoothService?.peripheralBLE?.setNotifyValue(true, for: positionCharacteristic)
      }
    }
  }

  init(initWithPeripheral peripheral: CBPeripheral) {
    super.init()
    self.peripheral = peripheral
    self.peripheral?.delegate = self
  }

  deinit {
    self.reset()
  }

  func startDiscoveringServices() {
    self.peripheral?.discoverServices(nil)
  }

  func reset() {
    if peripheral != nil {
      peripheral = nil
    }
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
      Router.bluetoothService?.peripheralBLE?.readValue(for: characteristic)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
      guard let value = characteristic.value else { return }
      let array = [UInt8](value)
      didUpdatedValue?(array)
//      logger.info("Twin didUpdateValueFor: ", array)
    }
    
  }
  
extension PeripheralService {
  func write(uInt8textArray: String) {
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
      self.peripheral?.writeValue(Data(bytes: uIntArray), for: positionCharacteristic, type: writeType)
    }
    
  }

}
