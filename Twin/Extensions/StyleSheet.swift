//
//  StyleSheet.swift
//  Twin
//
//  Created by Burak Üstün on 17.09.2018.
//  Copyright © 2018 TWIN. All rights reserved.
//

import UIKit

enum Stylesheet {
  enum Label {
    static let cellTitle = Style<UILabel> {
      $0.textColor = .greyishBrown
      $0.textAlignment = .left
      $0.font = .museoSans(ofSize: Utils.shared.calculateFontSize(with: 18), weight: .ms900)
      $0.adjustsFontSizeToFitWidth = true
      $0.text = ""
    }

    static let addItemTitle = Style<UILabel> {
      $0.textColor = .white
      $0.textAlignment = .center
      $0.font = .museoSans(ofSize: Utils.shared.calculateFontSize(with: 18), weight: .ms900)
      $0.text = ""
    }

    static let MainTitle = Style<UILabel> {
      $0.textColor = .black
      $0.textAlignment = .center
      $0.font = .museoSans(ofSize: Utils.shared.calculateFontSize(with: 23), weight: .ms900)
    }

    static let CodeLabel = Style<UILabel> {
      $0.textColor = .greyishBrown
      $0.textAlignment = .left
      $0.numberOfLines = 0
      $0.font = .museoSans(ofSize: 15, weight: .ms500)
    }

    static let PopupSubtitle = Style<UILabel> {
      $0.textColor = .greyishBrown
      $0.textAlignment = .center
      $0.font = .museoSans(ofSize: 16, weight: .ms500)
      $0.text = ""
      $0.numberOfLines = 0
    }

    static let PopupTitle = Style<UILabel> {
      $0.textColor = .greyishBrown
      $0.textAlignment = .center
      $0.font = .museoSans(ofSize: 16, weight: .ms900)
      $0.text = ""
      $0.numberOfLines = 0
    }
  }

  enum ImageView {
    static let fit = Style<UIImageView> {
      $0.contentMode = .scaleAspectFit
    }

    static let fill = Style<UIImageView> {
      $0.contentMode = .scaleAspectFill
    }

    static let fillWithShadow = Style<UIImageView> {
      $0.contentMode = .scaleAspectFill
      $0.layer.cornerRadius = 30
      $0.layer.masksToBounds = false
      $0.clipsToBounds = true
      $0.layer.shadowColor = UIColor.black.cgColor
      $0.layer.shadowOpacity = 0.3
      $0.layer.shadowOffset = CGSize(width: 0, height: 0)
      $0.layer.shadowRadius = 8
    }
  }

  enum NavigationBar {
    static let clear = Style<UINavigationBar> {
      $0.shadowImage = UIImage()
      $0.isTranslucent = true
      $0.setBackgroundImage(UIImage(), for: .default)
    }

    static let clearNotTranslucent = Style<UINavigationBar> {
      $0.shadowImage = UIImage()
      $0.isTranslucent = false
      $0.setBackgroundImage(UIImage(), for: .default)
      $0.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
      UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black,
                                                           .font: UIFont.boldSystemFont(ofSize: 20)], for: .normal)
      UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black,
                                                           .font: UIFont.boldSystemFont(ofSize: 20)], for: .highlighted)
    }
  }

  enum ToolBar {
    static let clear = Style<UIToolbar> {
      $0.setShadowImage(UIImage(), forToolbarPosition: .any)
      $0.isTranslucent = true
      $0.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
    }

  }

  enum View {
    static let shadow = Style<UIView> {
      $0.layer.cornerRadius = 10
      $0.layer.masksToBounds = false
      $0.backgroundColor = .white
      $0.layer.shadowColor = UIColor.black.cgColor
      $0.layer.shadowOpacity = 0.4
      $0.layer.shadowOffset = CGSize(width: 0, height: 0)
      $0.layer.shadowRadius = 8
    }

    static let indicator = Style<UIView> {
      $0.layer.masksToBounds = false
      $0.backgroundColor = .aquamarine
      $0.layer.shadowColor = UIColor.aquamarine.cgColor
      $0.layer.shadowOpacity = 0.5
      $0.layer.shadowOffset = CGSize(width: 0, height: 0)
      $0.layer.shadowRadius = 8
    }
  }
  
  enum TextField {
    static let popup = Style<UITextField> {
      $0.backgroundColor = UIColor(red: 240, green: 240, blue: 240)
      $0.font = UIFont.museoSans(ofSize: 14, weight: .ms700)
      $0.layer.cornerRadius = 22.5
      $0.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
    }
  }

  enum Button {
    static let back = Style<UIButton> {
      $0.setImageForAllStates(#imageLiteral(resourceName: "back"))
      $0.setTitleForAllStates("Global_Back".localized)
      $0.backgroundColor = .pinkishGrey
      $0.titleLabel?.font = .museoSans(ofSize: 14, weight: .ms900)
      $0.layer.shadowColor = UIColor.pinkishGrey.cgColor
      $0.layer.shadowOpacity = 0.5
      $0.layer.shadowOffset = CGSize(width: 0, height: 0)
      $0.layer.shadowRadius = 5
      $0.layer.masksToBounds = false
    }

    static let next = Style<UIButton> {
      $0.setImageForAllStates(#imageLiteral(resourceName: "rightArrow"))
      $0.setTitleForAllStates("Global_Next".localized)
      $0.backgroundColor = .aquamarine
      $0.titleLabel?.font = .museoSans(ofSize: 14, weight: .ms900)
      $0.layer.shadowColor = UIColor.aquamarine.cgColor
      $0.layer.shadowOpacity = 0.5
      $0.layer.shadowOffset = CGSize(width: 0, height: 0)
      $0.layer.shadowRadius = 5
      $0.layer.masksToBounds = false
    }

    static let ok = Style<UIButton> {
      $0.setTitleForAllStates("Global_Ok".localized)
      $0.backgroundColor = .aquamarine
      $0.titleLabel?.font = .museoSans(ofSize: 14, weight: .ms900)
      $0.layer.shadowColor = UIColor.aquamarine.cgColor
      $0.layer.shadowOpacity = 0.5
      $0.layer.shadowOffset = CGSize(width: 0, height: 0)
      $0.layer.shadowRadius = 5
      $0.layer.masksToBounds = false
    }

    static let disk = Style<UIButton> {
      $0.setImageForAllStates(#imageLiteral(resourceName: "120Diskette"))
      $0.setTitleForAllStates("")
      $0.backgroundColor = .aquamarine
      $0.layer.shadowColor = UIColor.aquamarine.cgColor
      $0.layer.shadowOpacity = 0.5
      $0.layer.shadowOffset = CGSize(width: 0, height: 0)
      $0.layer.shadowRadius = 5
      $0.layer.masksToBounds = false
    }

    static let run = Style<UIButton> {
      if let image = UIImage(named: "runIcon") {
        $0.setImageForAllStates(image)
      }
      $0.setTitleForAllStates("")
      $0.backgroundColor = .aquamarine
      $0.layer.shadowColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1).cgColor
      $0.layer.shadowOpacity = 0.5
      $0.layer.shadowOffset = CGSize(width: 0, height: 0)
      $0.layer.shadowRadius = 5
      $0.layer.masksToBounds = false
    }

    static let shadow = Style<UIButton> {
      $0.setTitleColorForAllStates(.white)
      $0.titleLabel?.font = .museoSans(ofSize: 15, weight: .ms900)
      $0.layer.shadowOpacity = 0.5
      $0.layer.shadowOffset = CGSize(width: 0, height: 0)
      $0.layer.shadowRadius = 5
      $0.layer.cornerRadius = 20
      $0.layer.masksToBounds = false
    }
    
    static let popupAquamarine = Style<UIButton> {
      $0.apply(Stylesheet.Button.shadow)
      $0.backgroundColor = .aquamarine
      $0.layer.shadowColor = UIColor.aquamarine.cgColor
    }
    
    static let popupGreyish = Style<UIButton> {
      $0.apply(Stylesheet.Button.shadow)
      $0.backgroundColor = .greyishBrown
      $0.layer.shadowColor = UIColor.greyishBrown.cgColor
    }

    static let twin = Style<UIButton> {
      $0.setImageForAllStates(#imageLiteral(resourceName: "twinStripes"))
      $0.setTitleForAllStates("")
      $0.backgroundColor = .aquamarine
      $0.layer.shadowColor = UIColor.aquamarine.cgColor
      $0.layer.shadowOpacity = 0.5
      $0.layer.shadowOffset = CGSize(width: 0, height: 0)
      $0.layer.shadowRadius = 5
      $0.layer.masksToBounds = false
    }

    static let aquamarine = Style<UIButton> {
      $0.backgroundColor = .aquamarine
      $0.titleLabel?.font = .museoSans(ofSize: Utils.shared.calculateFontSize(with: 15), weight: .ms900)
      $0.layer.cornerRadius = Utils.const(25)
    }

    static let clear = Style<UIButton> {
      $0.backgroundColor = .clear
      $0.titleLabel?.font = .museoSans(ofSize: Utils.shared.calculateFontSize(with: 15), weight: .ms900)
      $0.layer.cornerRadius = Utils.const(25)
      $0.layer.borderWidth = 1
      $0.layer.borderColor = UIColor.white.cgColor
    }
  }
}
