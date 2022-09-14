//
//  SplashViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 2/20/22.
//

import UIKit
import CoreTelephony

class SplashViewController: UIViewController {

    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        imageViewBackground.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "splash_black.png") : UIImage(named: "splash_img.png"))
        imageViewBackground.contentMode = UIView.ContentMode.scaleToFill
        self.view.addSubview(imageViewBackground)
        self.view.sendSubviewToBack(imageViewBackground)
        
        if self.traitCollection.userInterfaceStyle == .dark {
            UserDefaults.standard.set("dark", forKey: "ThemeAppereance")
        }
        else {
            UserDefaults.standard.set("light", forKey: "ThemeAppereance")
        }
        
        colorLine = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00) : UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00))

        colorGrayWhite = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.00) : UIColor.white)

        contentColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.19, green: 0.19, blue: 0.20, alpha: 1.00) : UIColor.white)
        
        toolbarColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.19, green: 0.19, blue: 0.20, alpha: 1.00) : UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00))
        
        colorBlackWhite = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor.white : UIColor.black)

        colorLightDarkGray = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.00) : UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00))

        colorLightDarkGray2 = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1.00) : UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00))
        
        darkGrayLight = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00) : UIColor.darkGray)
        
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(touches), userInfo: nil, repeats: false)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc func touches() {
        //UserDefaults.standard.set("light", forKey: "ThemeAppereance")
        
        if UserDefaults.standard.string(forKey: "mobPhone") != nil && UserDefaults.standard.string(forKey: "mobPhone") != "" && UserDefaults.standard.string(forKey: "PinCode") != "" && UserDefaults.standard.string(forKey: "PinCode") != nil
        {
            
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(PinCodeInputController(), animated: false)
        }
        else {
            
              self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
              navigationController?.pushViewController(AuthorizationViewController(), animated: false)
          }
        
      }
    
}


