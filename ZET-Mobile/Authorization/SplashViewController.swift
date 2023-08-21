//
//  SplashViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 2/20/22.
//

import UIKit
import CoreTelephony

struct ResultsData: Decodable {
    let version: String
}

struct AppStoreData: Decodable {
    let results: [ResultsData]
}


class SplashViewController: UIViewController {

    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        imageViewBackground.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "splash_black.png") : UIImage(named: "splash_white.png"))
        imageViewBackground.contentMode = .scaleAspectFill
        view.addSubview(imageViewBackground)
        view.sendSubviewToBack(imageViewBackground)
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            self.touches()
        }
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
            checkVersion()
        }
        else {
            
              self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
              navigationController?.pushViewController(AuthorizationViewController(), animated: false)
          }
        
      }
    
    func restartApp() {
        
       self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
       navigationController?.pushViewController(PinCodeInputController(), animated: false)
       
    }
    
    
    func checkVersion() {
          let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?
          let version = nsObject as! String
          let nsObject2: AnyObject? = Bundle.main.infoDictionary!["CFBundleVersion"] as AnyObject?
          let build = nsObject2 as! String
          let identifier = Bundle.main.infoDictionary!["CFBundleIdentifier"] as? String
    
          let url = URL(string: "http://itunes.apple.com/tj/lookup?bundleId=com.zet-mobile.Salom")!
       
          let session = URLSession(configuration: URLSessionConfiguration.default)
             
          let task = session.dataTask(with: url) { (data, response, error) in
                 
          if let data = data {
              do {
                  let things = try JSONDecoder().decode(AppStoreData.self, from: data)
                 
                  DispatchQueue.main.async  {
                          print(version)
                      if (version != things.results[0].version) {
                        print(things.results[0].version)
                              print("Please Update")
                          let alert = UIAlertController(title: "Доступно новое обновление ", message: "", preferredStyle: .alert)
                         
                          
                          let cancel = UIAlertAction(title: "Не сейчас", style:.default){ (action) in
                              self.restartApp()
                              alert.dismiss(animated: false, completion: nil)
                          }
                          
                          
                          let update = UIAlertAction(title: "Обновить", style:.default){ (action) in
                              if let url = URL(string: "https://apps.apple.com/tj/app/zet-mobile/id1503154544") {
                                  if #available(iOS 10, *) {
                                      UIApplication.shared.open(url, options: [:],
                                                                completionHandler: {
                                                                  (success) in
                                          self.restartApp()
                                      })
                                  } else {
                                      _ = UIApplication.shared.openURL(url)
                                  }
                              }
                              
                          }
                          alert.addAction(cancel)
                          alert.addAction(update)
                          self.present(alert, animated: true, completion: nil)
                          
                          }
                          else {
                              self.restartApp()
                          }
                          
                      }
                  }  catch let error as NSError {
                  }
              } else if let error = error {
              }
              if let response = response {
              }
          }
          task.resume()
    }
    
}


