//
//  AppDelegate.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/2/21.
//

import UIKit
import YandexMapKit
import Firebase
import FirebaseMessaging
import UserNotifications

import LocalAuthentication
import CoreLocation
import SideMenu

    var window = UIApplication.shared.keyWindow
    var topPadding = window?.safeAreaInsets.top
    var bottomPadding = window?.safeAreaInsets.bottom


extension UIApplication {
    
    
    static func topViewController(base: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
    
    var statusBarView: UIView? {
            if responds(to: Selector(("statusBar"))) {
                return value(forKey: "statusBar") as? UIView
            }
            return nil
        }
  
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    var locationManager: CLLocationManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
               
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound,.badge]){success, _ in
        guard success else {
            return
        }
            print("Success APNS registry")
                   
        }
               
        application.registerForRemoteNotifications()
               
        window = UIWindow()
        window?.makeKeyAndVisible()
        let navController = UINavigationController(rootViewController: SplashViewController())
        window?.rootViewController = navController
      
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways){
          //  locationManager.requestLocation()
            locationManager.startUpdatingLocation()
        }
        
        YMKMapKit.setApiKey("c60358d9-a157-4952-b448-7b1aea6c5e54")
        YMKMapKit.sharedInstance()
        
        switch UserDefaults.standard.integer(forKey: "language") {
            case 1:
                AMPLocalizeUtils.defaultLocalizer.setSelectedLanguage(lang: .ru)
                UserDefaults.standard.set(LanguageType.ru.rawValue, forKey: "language_string")
                break
            case 2:
                AMPLocalizeUtils.defaultLocalizer.setSelectedLanguage(lang: .en)
                UserDefaults.standard.set(LanguageType.en.rawValue, forKey: "language_string")
                break
            case 3:
                AMPLocalizeUtils.defaultLocalizer.setSelectedLanguage(lang: .tj)
                UserDefaults.standard.set(LanguageType.tj.rawValue, forKey: "language_string")
                break
            case 4:
                AMPLocalizeUtils.defaultLocalizer.setSelectedLanguage(lang: .uz)
                UserDefaults.standard.set(LanguageType.uz.rawValue, forKey: "language_string")
                break
            default:
                AMPLocalizeUtils.defaultLocalizer.setSelectedLanguage(lang: .ru)
                UserDefaults.standard.set(LanguageType.ru.rawValue, forKey: "language_string")
                break
        }
        
        return true
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token{ token, _ in
        guard let token = token else {
            return
        }
        UserDefaults.standard.set(token, forKey: "fbaseToken")
        print("Token : \(token)")
                
        }
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
  
    func setupLocationManager(){
        
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways){
            //  locationManager.requestLocation()
            locationManager.startUpdatingLocation()
        }
        
    }
    
    // Below method will provide you current location.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation: CLLocation = locations[locations.count - 1]
        lat = String(format: "%.6f", lastLocation.coordinate.latitude)
        long = String(format: "%.6f", lastLocation.coordinate.longitude)
        accur = String(format: "%.6f", lastLocation.verticalAccuracy)
    }
    
    // Below Mehtod will print error if not able to update location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("location manager authorization status changed")
        
        if(status == .authorizedWhenInUse || status == .authorizedAlways){
           // manager.requestLocation()
            manager.startUpdatingLocation()
        }
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {

  // This function will be called when the app receive notification
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      
    // show the notification alert (banner), and with sound
       completionHandler([.alert, .sound])
  }
    
  // This function will be called right after user tap on the notification
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
      
      let application = UIApplication.shared
        
        if(application.applicationState == .active){
          print("user tapped the notification bar when the app is in foreground")
           /* window = UIWindow()
            window?.makeKeyAndVisible()
            let navController = UINavigationController(rootViewController: ContainerViewController())
            window?.rootViewController = navController
            
            navController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navController.navigationController?.pushViewController(PushViewController(), animated: true)*/
        }
        
        if(application.applicationState == .inactive)
        {
          print("user tapped the notification bar when the app is in background")
            
           /* window = UIWindow()
            window?.makeKeyAndVisible()
            let navController = UINavigationController(rootViewController: ContainerViewController())
            window?.rootViewController = navController
            
            navController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navController.navigationController?.pushViewController(PushViewController(), animated: true)
           
            guard let window = UIApplication.shared.keyWindow else {
               return
            }

            guard let rootViewController = window.rootViewController else {
               return
            }
            let vc = ContainerViewController()
            vc.view.frame = rootViewController.view.frame
            vc.view.layoutIfNeeded()
            UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromLeft, animations: {
                   window.rootViewController = vc
             }, completion: nil)*/
        }
        
        /* Change root view controller to a specific viewcontroller */
        // let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // let vc = storyboard.instantiateViewController(withIdentifier: "ViewControllerStoryboardID") as? ViewController
        // self.window?.rootViewController = vc
        
        completionHandler()
  }
}
