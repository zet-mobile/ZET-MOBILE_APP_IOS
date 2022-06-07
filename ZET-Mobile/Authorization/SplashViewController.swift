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
        imageViewBackground.image = UIImage(named: "splash_img.png")
        imageViewBackground.contentMode = UIView.ContentMode.scaleToFill
        self.view.addSubview(imageViewBackground)
        self.view.sendSubviewToBack(imageViewBackground)
        
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
            UserDefaults.standard.set(1, forKey: "language")
            UserDefaults.standard.set(LanguageType.ru.rawValue, forKey: "language_string")
            self.defaultLocalizer.setSelectedLanguage(lang: .ru)
            
              self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
              navigationController?.pushViewController(AuthorizationViewController(), animated: false)
          }
        
      }
    
}


