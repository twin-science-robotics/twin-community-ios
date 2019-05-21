//
//  BlockyViewController.swift
//  Twin
//
//  Created by Burak Üstün on 25.09.2018.
//  Copyright © 2018 TWIN. All rights reserved.
//

import UIKit
import Blockly

class BlocklyViewController: BaseUIViewController {
  
  convenience init(_ projectId: String, defaultPath: String? = nil) {
    self.init()
    MessageManager.shared.updateLanguage(Language.language.rawValue)
    blocklyHelper = BlocklyHelper(projectId, path: defaultPath)
    self.projectId = projectId
    self.isDefaultProject = defaultPath != nil
  }
  
  convenience init(projectId: String) {
    self.init()
    self.projectId = projectId
    MessageManager.shared.updateLanguage(Language.language.rawValue)
    blocklyHelper = BlocklyHelper(projectId)
    self.isDefaultProject = false
  }
  
  deinit {
    logger.debug("")
  }
  
  private var isRunning = false {
    didSet {
      DispatchQueue.main.async {
        if self.isRunning {
          if let image = UIImage(named: "stopIcon") {
            self.runButton.setImageForAllStates(image)
            self.runButton.imageEdgeInsets = .zero
          }
        } else {
          if let image = UIImage(named: "runIcon") {
            self.runButton.setImageForAllStates(image)
            self.runButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
          }
        }
      }
    }
  }
  
  private var isConnected = false
  private var isDefaultProject = true
  var blocklyHelper: BlocklyHelper!
  let diskButton = UIButton(style: Stylesheet.Button.disk, action: #selector(onSaveButtonClick(_:)))
  let runButton = UIButton(style: Stylesheet.Button.run, action: #selector(onRunButtonClick))
  let backgroundImageView = UIImageView(image: UIImage(named: "blocklyGrid"))
  var projectId: String!
  var bluetoothService:CoreBluetoothService? = CoreBluetoothService()
  let helper = GyroscopeHelper()
  lazy var filter:NSPredicate = {
    if isDefaultProject {
      return NSPredicate(format: "projectID == %@ and langCode == %@", projectId, Language.language.rawValue)
    } else {
      return NSPredicate(format: "projectID == %@", projectId)
    }
    
  }()
  lazy var projectName:String? = RealmWrapper.shared.objects(ProjectModel.self, filter: filter).first?.title
  
  var isNewProject: Bool {
    return navigationBar?.title == "BlocklyViewController_NewProject".localized
  }
  
  override var canBecomeFirstResponder: Bool {
    return true
  }
  
  var shake: (() -> Void)?
  // Enable detection of shake motion
  override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    if motion == .motionShake {
      Utils.shared.didShake = true
    }
  }
  
  var generatedCode: String? {
    didSet {
      diskButton.isEnabled = generatedCode != nil
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    Router.blocklyViewController = self
    self.becomeFirstResponder()
    configureViews()
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handleJsError(_:)),
                                           name: .javascriptError,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(onTwinConnect),
                                           name: .twinConnected,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(onTwinDisconnect),
                                           name: .twinDisconnected,
                                           object: nil)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    removeGestureRecognizer()
    logger.debug("")
    blocklyHelper.runner.stopJavascriptCode()
    NotificationCenter.default.removeObserver(self, name: .javascriptError, object: nil)
    NotificationCenter.default.removeObserver(self, name: .twinConnected, object: nil)
    NotificationCenter.default.removeObserver(self, name: .twinDisconnected, object: nil)
    if let peripheral = bluetoothService?.currentPeripheral {
      bluetoothService?.bluetoothManager?.cancelPeripheralConnection(peripheral)
    }
   
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
     bluetoothService?.clearDevices()
  }
  
  fileprivate func initializeWithProjectStatus() {
    let backButton = UIButton(style: Stylesheet.Button.back, action: #selector(onBackButtonClick(_:)))
    guard let project = RealmWrapper.shared.objects(ProjectModel.self, filter: filter).first else {
      // New Project
      buildController(settings: .blockly,
                      title: "BlocklyViewController_NewProject".localized,
                      leftItems: [backButton],
                      rightItems: [diskButton, runButton])
      return
    }
    switch isDefaultProject {
    case true:
      buildController(settings: .blockly,
                      title: project.title,
                      leftItems: [backButton],
                      rightItems: [runButton])
    case false:
      buildController(settings: .blockly,
                      title: project.title,
                      leftItems: [backButton],
                      rightItems: [diskButton, runButton]).onTitleTap(self.showRenamePopup())
    }
  }
  
  func handleSaveProject(onSuccess:(() -> Void)? = nil) {
    if isNewProject {
      PopupManager.standart.show(type: .textField, title: "BlocklyViewController_GiveProjectName".localized, { (text) in
        guard let text = text, text != "" else {
          //Proje adi burda handle edilebilir.
          return
        }
        RealmWrapper.shared.add(object: ProjectModel(self.projectId, title: text, isMine: true))
        PopupManager.standart.dismiss(onCompletion: {
          self.navigationBar?.set(title: text)
          self.saveWorkspace(onSuccess: onSuccess)
          self.onTitleTap(self.showRenamePopup())
        })
      })
    } else {
      PopupManager.standart.dismiss {
      self.saveWorkspace(onSuccess: onSuccess)
      }
    }
  }
  
  fileprivate func saveWorkspace(onSuccess:(() -> Void)? = nil) {
    self.blocklyHelper.saveWorkspace({ (result) in
      PopupManager.standart.show(type: .regular,
                                 title: result ? "BlocklyViewController_Save_Success".localized
                                  : "BlocklyViewController_Save_Failure".localized,
                                 nil,
                                 onCancel: {
                                  onSuccess?()
      })
    })
  }
  
  fileprivate func onCodeGenereationCompleted(code: String) {
    logger.debug("🚀🚀🚀 Generated Code:", context: code)
    generatedCode = code
    blocklyHelper.currentRequestUUID = ""
    blocklyHelper.runner.runJavascriptCode(code) {
      self.isRunning = false
    }
  }
  
  fileprivate func onCodeGenerationFailed(error: String) {
    generatedCode = nil
    self.isRunning = false
    logger.debug("Code run failed", context: error)
  }
  
  private func showConnectToTwinPopup() {
    Router.bluetoothService?.startScanning()
  }
  
  @objc private func showRenamePopup() {
    PopupManager.standart.show(type: .textField,
                               title: "BlocklyViewController_GiveProjectName".localized,
                               text: projectName, { text in
                                guard let text = text, text != "" else { return }
                                RealmWrapper.shared.update(name: text, projectId: self.projectId)
                                self.navigationBar?.set(title: text)
    })
  }
  
  func configureViews() {
    runButton.layer.shadowColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1).cgColor
    view.backgroundColor = .white
    view.addSubview(views: backgroundImageView)
    backgroundImageView.fill(.all)
    initializeWithProjectStatus()
    let backView = UIView(backgroundColor: .white)
    view.addSubview(backView)
    backView.frame = CGRect(x: 0, y: 0, width: blocklyHelper.workbenchViewController.categoryWidth, height: navHeight)
    view.bringSubviewToFront(navigationBar!)
    addChild(blocklyHelper.workbenchViewController)
    contentView.addSubview(blocklyHelper.workbenchViewController.view)
    blocklyHelper.workbenchViewController.view.backgroundColor = .clear
    blocklyHelper.workbenchViewController.view.frame = contentView.bounds
    blocklyHelper.workbenchViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    blocklyHelper.workbenchViewController.didMove(toParent: self)
  }
  
}

//Actions
extension BlocklyViewController {
  
  @objc func onRunButtonClick() {
    guard Router.bluetoothService?.peripheralService?.characteristics != nil else {
      self.showConnectToTwinPopup()
      self.isRunning = false
      return
    }
    
    if isRunning {
      blocklyHelper.runner.stopJavascriptCode()
      logger.debug("Stop Javascript Code 🏁")
      isRunning = false
    } else {
      blocklyHelper.generateCode(onCompletion: { (_, code) in
        logger.debug("Start Javascript Code ✈️")
        self.isRunning = true
        self.onCodeGenereationCompleted(code: code)
      }, onError: { _, error in
        self.onCodeGenerationFailed(error: error)
      })
    }
  }
  
  @objc func onBackButtonClick(_ button: UIButton) {
    if isDefaultProject {
      navigationController?.popViewController(animated: true)
    } else {
      if blocklyHelper.checkProjectDifference() {
        navigationController?.popViewController(animated: true)
      } else {
        PopupManager.standart.show(type: .twoButton,
                                   title: "BlocklyViewController_ExitWithoutSave".localized,
                                   yes: "Global_Save".localized,
                                   no: "Global_Dont_Save".localized, { (_) in
                                    PopupManager.standart.dismiss(onCompletion: {
                                      self.handleSaveProject(onSuccess: {
                                        self.navigationController?.popViewController(animated: true)
                                      })
                                    })
        }, onCancel: {
          self.navigationController?.popViewController(animated: true)
        })
      }
    }
  }
  
  @objc func onSaveButtonClick(_ button: UIButton) {
    handleSaveProject()
  }
  
}

//Handlers
extension BlocklyViewController {
  @objc func handleJsError(_ notification: NSNotification) {
    guard let userInfo = notification.userInfo, let errorMessage = userInfo["error"] as? String else {
      return
    }
    PopupManager.standart.show(type: .regular, title: errorMessage.localized, { (_) in
    }, onCancel: nil)
  }
  
  @objc func onTwinConnect() {
    guard !isConnected else {
      logger.error("Already Connected")
      return
    }
    logger.verbose("on Twin Disconnected")
    isConnected = true
    DispatchQueue.main.async {
        PopupManager.standart.updatePopup(text: "BlocklyViewController_ConnectedSuccesfully".localized)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
          PopupManager.standart.dismiss(onCompletion: {
            self.runButton.layer.shadowColor = UIColor.aquamarine.cgColor
            self.onRunButtonClick()
          })
        })
    }
  }
  
  @objc func onTwinDisconnect() {
    guard isConnected else {
      logger.error("Already Disconnected")
      return
    }
    logger.verbose("Twin Connected")
    isConnected = false
    DispatchQueue.main.async {
      PopupManager.standart.dismiss(onCompletion: {
        PopupManager.standart.show(type: .regular, title: "BlocklyViewController_Disconnected".localized, { (_) in
        })
        DispatchQueue.userInitiated.async {
          self.bluetoothService?.clearDevices()
          self.blocklyHelper.runner.stopJavascriptCode()
        }
        self.runButton.layer.shadowColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1).cgColor
        self.isRunning = false
      })
    }
  }
  
}
