//
//  CodeRunner.swift
//  Twin
//
//  Created by Burak Üstün on 12.10.2018.
//  Copyright © 2018 TWIN. All rights reserved.
//

import Foundation
import JavaScriptCore

class CodeRunner {
  private let jsThread = DispatchQueue(label: "BlockyJSThread", qos: .background)
  private var context = JSContext()
  
  init() {
    configureExceptionHandler()
    self.context?.setObject(TwinSoftwareModule.self, forKeyedSubscript: "Twin" as NSString)
  }
  
  private func configureExceptionHandler() {
    self.context?.exceptionHandler = { context, exception in
      guard let error = exception?.description else { return }
      switch error {
      case let str where str.contains("Code evaluation stopped by client."):
        NotificationCenter.default.post(name: .javascriptError, object: nil)
        logger.error("JSERROR: Code Stop")
        
      case let str where str.contains("Infinite loop."):
        NotificationCenter.default.post(name: .javascriptError, object: nil, userInfo: ["error" : "BlocklyViewController_JSError_InfiniteLoop"])
        logger.error("JSERROR: Infinite Loop")
      default:
        logger.error("JSERROR: Generic")
      }
    }
  }

  /**
   Runs Javascript code on a background thread.
   
   - parameter code: The Javascript code.
   - parameter completion: Closure that is called on the main thread when the code has finished
   executing.
   */
  func runJavascriptCode(_ code: String, completion: @escaping () -> Void) {
    logger.debug("Blockly: evaluate JS")
    
    guard let helperUrl = Bundle.main.url(forResource: "twin_helper", withExtension: "js"),
      let data = try? String(contentsOf: helperUrl)  else {
        logger.error("Missing JS library")
      return
    }
    
    jsThread.async {
      self.context?.evaluateScript(data)
      self.context?.evaluateScript(code)
      
      DispatchQueue.main.async {
        completion()
      }
    }
    
  }

  func stopJavascriptCode() {
    self.context?.evaluateScript("TwinHelper.setEvaluationStopStatus(true);")
  }
}
