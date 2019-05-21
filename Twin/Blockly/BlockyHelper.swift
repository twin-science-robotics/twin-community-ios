//
//  BlockyHelper.swift
//  Twin
//
//  Created by Burak Üstün on 27.09.2018.
//  Copyright © 2018 YGA. All rights reserved.
//

import Foundation
import Blockly

class BlocklyHelper {
  
  public var runner: CodeRunner = CodeRunner()
  
  var projectID: String?
  var defaultPath: String?
  // MARK: - Properties
  
  convenience init(_ projectId: String, path: String? = nil) {
    self.init()
    self.projectID = projectId
    self.defaultPath = path
    configureBlockly()
  }
  
  init() {}
  
  lazy var workbenchViewController: WorkbenchViewController = {
    var workbenchViewController = WorkbenchViewController(style: .defaultStyle)
    workbenchViewController.delegate = self
    workbenchViewController.toolboxDrawerStaysOpen = false
    workbenchViewController.workspaceBackgroundColor = .white
    workbenchViewController.allowZoom = false
    workbenchViewController.allowUndoRedo = false
    return workbenchViewController
  }()
  
  var codeGeneratorService: CodeGeneratorService = {
    let codeGeneratorService = CodeGeneratorService(jsCoreDependencies: ["blockly_compressed.js", "en.js"])
    let builder = CodeGeneratorServiceRequestBuilder(jsGeneratorObject: "Blockly.JavaScript")
    builder.addJSONBlockDefinitionFiles(fromDefaultFiles: .allDefault)
    builder.addJSONBlockDefinitionFiles([String(format: "block_definitions_%@.json", Language.language.rawValue)])
    builder.addJSBlockGeneratorFiles(["javascript_compressed.js", "twin.js"])
    codeGeneratorService.setRequestBuilder(builder, shouldCache: true)
    return codeGeneratorService
  }()
  
  var currentlyRunning = false
  var allowBlockHighlight = false
  var allowScrollingToBlockView = false
  var lastHighlightedBlockUUID: String?
  var currentRequestUUID: String? = ""
  let dateFormatter = DateFormatter()
  
  func configureBlockly() {
    workbenchViewController.blockFactory.load(fromDefaultFiles: .allDefault)
    do {
      let jsonPath = String(format: "block_definitions_%@.json", Language.language.rawValue)
      print(jsonPath)
      try workbenchViewController.blockFactory.load(fromJSONPaths: [jsonPath])
    } catch let error {
      logger.error("Blockly: An error occurred loading the turtle blocks: \(error)")
    }
    // Load the toolbox
    do {
      let toolboxPath = String(format: "toolbox_%@.xml", Language.language.rawValue)
      print(toolboxPath)
      if let bundlePath = Bundle.main.path(forResource: toolboxPath, ofType: nil) {
        let xmlString = try String(contentsOfFile: bundlePath, encoding: String.Encoding.utf8)
        let toolbox = try Toolbox.makeToolbox(xmlString: xmlString, factory: workbenchViewController.blockFactory)
        
        try workbenchViewController.loadToolbox(toolbox)
      } else {
        logger.error("Blockly: Could not load toolbox XML from '\(toolboxPath)'")
      }
    } catch let error {
      logger.error("Blockly: An error occurred loading the toolbox: \(error)")
    }
    
    loadWorkspace()
  }
  
  @objc func generateCode(onCompletion: @escaping(_ requestUUID: String, _ code: String) -> Void, onError: @escaping (_ requestUUID: String, _ String: String) -> Void) {
    do {
      switch currentlyRunning {
      case true:
        guard currentRequestUUID != "", let uuid = currentRequestUUID else {
          logger.error("Blockly Error: The current request UUID is nil.")
          return
        }
        codeGeneratorService.cancelRequest(uuid: uuid)
        self.resetRequests()
      case false:
        guard let workspace = workbenchViewController.workspace else { return }
        currentRequestUUID =
          try codeGeneratorService.generateCode(forWorkspace: workspace, onCompletion: { (requestUUID, code) in
            onCompletion(requestUUID, code)
          }, onError: { (requestUUID, error) in
            onError(requestUUID, error)
          })
      }
    } catch let error {
      logger.error("Blockly: An error occurred generating code for the workspace: \(error)")
    }
  }
  
  fileprivate func resetRequests() {
    currentlyRunning = false
    currentRequestUUID = ""
  }
}

extension BlocklyHelper {
  // MARK: - Load/Save Workspace
  
  func saveWorkspace(_ isSuccess : @escaping ((Bool) -> Void)) {
    guard let projectID = projectID, let workspace = workbenchViewController.workspace else { return }
    do {
      let xml = try workspace.toXML()
      FileHelper.saveContents(xml, to: "\(projectID).xml")
      isSuccess(true)
    } catch let error {
      print(error.localizedDescription)
      isSuccess(false)
    }
  }
  
  func loadWorkspace() {
    guard let projectID = projectID,
      let xml = defaultPath != nil ? FileHelper.loadFromBundle(of: "\(defaultPath!).xml")
                                   : FileHelper.loadContents(of: "\(projectID).xml") else { return }
    do {
      let workspace = Workspace()
      try workspace.loadBlocks(fromXMLString: xml, factory: workbenchViewController.blockFactory)
      try workbenchViewController.loadWorkspace(workspace)
    } catch let error {
      logger.error("Blockly: Could not load workspace from disk: \(error)")
    }
  }
  
  func checkProjectDifference() -> Bool {
    guard let projectID = projectID, let workspace = workbenchViewController.workspace else { return false}
    do {
      let xml = try workspace.toXML()
      return FileHelper.checkDifference(xml, to: "\(projectID).xml")
    } catch let error {
      print(error.localizedDescription)
      return false
    }
  }
}

// MARK: - WorkbenchViewControllerDelegate implementation

extension BlocklyHelper: WorkbenchViewControllerDelegate {
  func workbenchViewController(_ workbenchViewController: WorkbenchViewController,
                               didUpdateState state: WorkbenchViewController.UIState) {
    // We need to disable automatic block view scrolling / block highlighting based on the latest
    // user interaction.
    
    if allowScrollingToBlockView {
      // Only continue to allow automatic scrolling if the user tapped on the workspace.
      allowScrollingToBlockView =
        state.isSubset(of: [workbenchViewController.stateDidTapWorkspace])
    }
    
    if allowBlockHighlight {
      // Only continue to allow block highlighting if the user tapped/panned the workspace or
      // opened either the toolbox or trash can.
      allowBlockHighlight = state.isSubset(of: [
        workbenchViewController.stateDidTapWorkspace,
        workbenchViewController.stateDidPanWorkspace,
        workbenchViewController.stateCategoryOpen,
        workbenchViewController.stateTrashCanOpen])
    }
  }
}
