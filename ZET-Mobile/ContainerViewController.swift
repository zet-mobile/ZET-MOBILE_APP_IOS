//
//  ContainerViewController.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/2/21.
//

import UIKit

class ContainerViewController: UITabBarController, UITabBarControllerDelegate {
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = colorBlackWhite
        tabBar.barTintColor = contentColor
        tabBar.backgroundColor = contentColor
        //Assign self for delegate for that ViewController can respond to UITabBarControllerDelegate methods
        self.delegate = self
        
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create Tab one
        let tabHome = UINavigationController(rootViewController: HomeViewController())

        let tabHomeBarItem:UITabBarItem = UITabBarItem(title: defaultLocalizer.stringForKey(key: "home"), image: UIImage(named: "Home")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "Home2")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        
        tabHome.tabBarItem = tabHomeBarItem
        
        
        // Create Tab two
        let tabWallet = WalletViewController()
        let tabWalletBarItem2 = UITabBarItem(title: defaultLocalizer.stringForKey(key: "Wallet"), image: UIImage(named: "Wallet")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "Wallet")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        
        tabWallet.tabBarItem = tabWalletBarItem2
        
        
        // Create Tab 3
        let tabUsage = UINavigationController(rootViewController: UsageViewController())
        let tabUsageBarItem3 = UITabBarItem(title: defaultLocalizer.stringForKey(key: "Expenses"), image: UIImage(named: "Usage")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "usage_orange")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        
        tabUsage.tabBarItem = tabUsageBarItem3
        
        // Create Tab 4
        let tabCallCenter = CallCenterViewController()
        let tabCallCenterBarItem4 = UITabBarItem(title: defaultLocalizer.stringForKey(key: "Support"), image: UIImage(named: "Call")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "Call_orange")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        
        tabCallCenter.tabBarItem = tabCallCenterBarItem4
        
        // Create Tab 4
        let tabProfile = ProfileViewController()
        let tabProfileBarItem5 = UITabBarItem(title: defaultLocalizer.stringForKey(key: "Profiles"), image: UIImage(named: "Profile")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "Profile_orange")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        
        tabProfile.tabBarItem = tabProfileBarItem5

        
        self.viewControllers = [tabHome, tabUsage, tabCallCenter]
    }
    
    // UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        tabBar.tintColor = colorBlackWhite
    }
}

