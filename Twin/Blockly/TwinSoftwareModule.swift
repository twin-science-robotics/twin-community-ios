//
 // TwinSoftwareModule.swift
 // Twin
 //
 // Created by Burak Üstün on 12.10.2018.
 // Copyright © 2018 TWIN. All rights reserved.
 //
 import Foundation
 import JavaScriptCore


 @objc protocol TwinJSExports: JSExport {
  static func resetDevice()
  static func sendMessage(_ message: String)
  static func getMessage(_ message: String, _ isAnalog: String) -> UInt16
  static func getDeviceShakeStatus() -> Bool
  static func getDeviceOrientation(_ orientation: String) -> Bool
  static func sleep(_ duration: String) -> Bool
 }

 @objc @objcMembers class TwinSoftwareModule: NSObject, TwinJSExports {

  static private let resetCode = "AA-44-1C-11-01-00"

  static func resetDevice() {
    logger.info("")
    Router.bluetoothService?.peripheralService?.write(resetCode)
  }

  static func sendMessage(_ message: String) {
    logger.debug(message)
    Router.bluetoothService?.peripheralService?.write(message)
    
    // Dirty hack for buzzer bug. We need to wait until playing completion
    if message.starts(with: "AA-44-1C-0F-02") {
      usleep(500000)
    }
  }

  static func getMessage(_ message: String, _ isAnalog: String) -> UInt16 {
    logger.debug(message)
    
    Router.bluetoothService?.peripheralService?.write(message)
    var result: UInt16 = 0
    let group = DispatchGroup()
    let queue = DispatchQueue.global()
    
    group.enter()
    queue.async(group: group) {
      Router.bluetoothService?.peripheralService?.didUpdatedValue = { response in
        guard let last = response.last else {
          group.leave()
          return }
        var msb = UInt16(last)
        var lsb = UInt16(0)
        
        if isAnalog == "1" {
          if response.count >= 2 {
            logger.error("Response is not valid.")
            lsb = UInt16(response[response.count - 2])
          }
        }
        msb = msb << 8
        result = msb + lsb
        logger.info("DispatchGroup", context: "Leave")
        group.leave()
      }
    }
    
    logger.info("DispatchGroup", context: "Wait")
    let _ = group.wait(timeout: .now() + 3)
    group.notify(queue: queue) {}

    return result
  }

  static func getDeviceShakeStatus() -> Bool {
    usleep(100000) //0.10s
    logger.debug(Utils.shared.didShake)
    return Utils.shared.didShake
  }

  static func getDeviceOrientation(_ orientation: String) -> Bool {
    guard let deviceOrientation = Utils.shared.orientation else { return false }
    usleep(100000) //0.10s
    logger.debug(deviceOrientation.rawValue)
    return orientation == deviceOrientation.rawValue
  }

  static func sleep(_ duration: String) -> Bool {

    guard let floatDuration = Float(duration) else { return false }
    let result = UInt32(floatDuration * 1000000)
    logger.debug(duration)
    usleep(result)

    return true
  }
 }
