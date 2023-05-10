//
//  SceneDelegate.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/2/21.
//

import UIKit
import YandexMapKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var totalTimeBack = 180
    
    var timerCountingBack: Bool = false
    var startTimeBack: Date?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
                window = UIWindow(frame: windowScene.coordinateSpace.bounds)
                window?.windowScene = windowScene
                let navController = UINavigationController(rootViewController: SplashViewController())
                window?.rootViewController = navController
                window?.makeKeyAndVisible()
        
        YMKMapKit.setApiKey("c60358d9-a157-4952-b448-7b1aea6c5e54")
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
       
    }

    func sceneWillEnterForeground(_ scene: UIScene) {

        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        guard let rootViewController = window.rootViewController else {
            return
        }
        
        if UserDefaults.standard.string(forKey: "mobPhone") != nil && UserDefaults.standard.string(forKey: "mobPhone") != "" && UserDefaults.standard.string(forKey: "PinCode") != "" && UserDefaults.standard.string(forKey: "PinCode") != nil && rootViewController != PinCodeInputController() && rootViewController != SplashViewController()
        {
            print("hi")
            
            let diff = Date().timeIntervalSince(startTimeBack ?? Date())
            
            print(Int(diff))
            if Int(diff) > totalTimeBack {
                
                let vc = PinCodeInputController()
                vc.view.frame = rootViewController.view.frame
                vc.view.layoutIfNeeded()
                UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromLeft, animations: {
                    window.rootViewController = vc
                }, completion: nil)
            }
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        startTimeBack = Date()
    }
    
}

